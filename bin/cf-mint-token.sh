#!/usr/bin/env bash
#
# Mints a short-lived Cloudflare credential from a durable Account API
# Token ("minter") stored in Bitwarden, and exports it into the current
# shell as:
#   TF_VAR_cloudflare_api_token  - for the cloudflare provider (DNS)
#   AWS_ACCESS_KEY_ID            - R2 S3-compatible credential (session state)
#   AWS_SECRET_ACCESS_KEY        - derived from the same minted token
#   AWS_ENDPOINT_URL_S3          - this account's R2 S3 endpoint
#   AWS_REGION / AWS_DEFAULT_REGION - "auto", as R2 requires
#
# The minted token is scoped to Zone Read + DNS Write (all zones) and
# read/write on one R2 bucket, expires on its own after --ttl-hours, and
# gets explicitly revoked early wherever this script can detect "done".
# Pass --r2-admin for Workers R2 Storage Write against the bare account
# resource (bucket create/delete/configure, account-wide) instead of the
# bucket-scoped object read/write grant — needed when managing R2 buckets
# themselves via the cloudflare_r2_bucket Terraform/OpenTofu resource.
#
# Requires: bw, curl, jq
#
# Bitwarden must contain a Login item (default name: cloudflare-token-minter)
# whose password is a Cloudflare Account API Token scoped to:
#   Account > Account API Tokens > Edit
#
# --- Usage 1: source it, then run tofu/tf normally ---------------------
#   . cf-mint-token.sh
#   tf plan
#   cf_revoke_token          # optional: revoke/lock early instead of
#                            #  waiting for shell exit or TTL expiry
#
#   Sourcing sets a trap that revokes the Cloudflare token and locks the
#   Bitwarden vault (bw lock, unconditionally — even if BW_SESSION was
#   already set by the caller) when the current shell exits, so closing
#   the terminal cleans up even if you forget.
#
# --- Usage 2: wrap a single command (e.g. for CI / one-offs) -----------
#   cf-mint-token.sh -- tf plan
#
#   Revokes and locks immediately after the wrapped command finishes.
#
# Both usages accept --ttl-hours N (default 4) and --r2-admin (see above).
#
# Env overrides:
#   CF_MINTER_BW_ITEM    Bitwarden item name (default: cloudflare-token-minter)
#   CF_ACCOUNT_ID        Cloudflare account ID (default: Abyss's account)
#   CF_R2_BUCKET         R2 bucket to grant read/write on (default: tf-state)
#   CF_R2_JURISDICTION   R2 bucket jurisdiction (default: default)
#   BW_SESSION           Reuse an already-unlocked Bitwarden session

_cf_mint_token_main() {
  local BW_ITEM_NAME CF_R2_BUCKET CF_R2_JURISDICTION TTL_HOURS R2_ADMIN
  local perm_groups_json zone_read_id dns_write_id r2_perm_id
  local token_name create_payload create_response aws_secret_access_key

  BW_ITEM_NAME="${CF_MINTER_BW_ITEM:-cloudflare-token-minter}"
  CF_ACCOUNT_ID="${CF_ACCOUNT_ID:-885a505f6539e438eab1aeedeca40a2e}"
  CF_R2_BUCKET="${CF_R2_BUCKET:-tf-state}"
  CF_R2_JURISDICTION="${CF_R2_JURISDICTION:-default}"
  TTL_HOURS=4
  R2_ADMIN=0

  while [[ $# -gt 0 ]]; do
    case "$1" in
      --ttl-hours)
        TTL_HOURS="$2"
        shift 2
        ;;
      --r2-admin)
        R2_ADMIN=1
        shift
        ;;
      --)
        shift
        break
        ;;
      *)
        echo "Unknown argument: $1" >&2
        return 1
        ;;
    esac
  done

  local bin
  for bin in bw curl jq; do
    command -v "$bin" >/dev/null 2>&1 || { echo "Missing dependency: $bin" >&2; return 1; }
  done

  api="https://api.cloudflare.com/client/v4"

  # --- Unlock Bitwarden (reuse BW_SESSION if the caller already has one) ---
  if [[ -z "${BW_SESSION:-}" ]]; then
    echo "Bitwarden vault locked, unlocking..." >&2
    BW_SESSION="$(bw unlock --raw)" || return 1
    export BW_SESSION
  fi

  minter_token="$(bw get password "$BW_ITEM_NAME" --session "$BW_SESSION")" || return 1
  if [[ -z "$minter_token" || "$minter_token" == "null" ]]; then
    echo "Bitwarden item '$BW_ITEM_NAME' has no password set." >&2
    return 1
  fi

  # --- Look up permission group IDs (names can vary slightly between accounts) ---
  perm_groups_json="$(curl -sS -H "Authorization: Bearer $minter_token" \
    "$api/accounts/$CF_ACCOUNT_ID/tokens/permission_groups")"

  if [[ "$(jq -r '.success' <<<"$perm_groups_json")" != "true" ]]; then
    echo "Failed to list permission groups:" >&2
    jq . <<<"$perm_groups_json" >&2
    return 1
  fi

  find_perm_id() {
    local name id
    for name in "$@"; do
      id="$(jq -r --arg n "$name" '.result[] | select(.name == $n) | .id' <<<"$perm_groups_json" | head -n1)"
      if [[ -n "$id" ]]; then
        echo "$id"
        return 0
      fi
    done
    echo "Could not find any permission group named: $*" >&2
    return 1
  }

  zone_read_id="$(find_perm_id "Zone Read")" || return 1
  dns_write_id="$(find_perm_id "DNS Write" "DNS Edit")" || return 1
  if [[ "$R2_ADMIN" == "1" ]]; then
    r2_perm_id="$(find_perm_id "Workers R2 Storage Write")" || return 1
  else
    r2_perm_id="$(find_perm_id "Workers R2 Storage Bucket Item Write")" || return 1
  fi

  # --- Compute expiry (BSD date on macOS, GNU date elsewhere) ---
  if date -v+1H >/dev/null 2>&1; then
    expires_on="$(date -u -v+"${TTL_HOURS}"H +"%Y-%m-%dT%H:%M:%SZ")"
  else
    expires_on="$(date -u -d "+${TTL_HOURS} hours" +"%Y-%m-%dT%H:%M:%SZ")"
  fi

  token_name="tofu-session-$(date -u +%Y%m%dT%H%M%SZ)"

  create_payload="$(jq -n \
    --arg name "$token_name" \
    --arg account_id "$CF_ACCOUNT_ID" \
    --arg zone_read_id "$zone_read_id" \
    --arg dns_write_id "$dns_write_id" \
    --arg r2_perm_id "$r2_perm_id" \
    --arg r2_admin "$R2_ADMIN" \
    --arg r2_bucket_resource "com.cloudflare.edge.r2.bucket.${CF_ACCOUNT_ID}_${CF_R2_JURISDICTION}_${CF_R2_BUCKET}" \
    --arg expires_on "$expires_on" \
    '{
      name: $name,
      policies: [
        {
          effect: "allow",
          resources: {
            ("com.cloudflare.api.account." + $account_id): {
              "com.cloudflare.api.account.zone.*": "*"
            }
          },
          permission_groups: [
            {id: $zone_read_id},
            {id: $dns_write_id}
          ]
        },
        {
          effect: "allow",
          resources: (
            if $r2_admin == "1" then
              # Workers R2 Storage Write is Account-scoped: attach it to
              # the bare account resource, not nested under anything
              # R2-shaped (both nesting attempts were rejected by the
              # Cloudflare API).
              {("com.cloudflare.api.account." + $account_id): "*"}
            else
              {($r2_bucket_resource): "*"}
            end
          ),
          permission_groups: [
            {id: $r2_perm_id}
          ]
        }
      ],
      expires_on: $expires_on
    }')"

  create_response="$(curl -sS -H "Authorization: Bearer $minter_token" \
    -H "Content-Type: application/json" \
    --data "$create_payload" \
    "$api/accounts/$CF_ACCOUNT_ID/tokens")"

  if [[ "$(jq -r '.success' <<<"$create_response")" != "true" ]]; then
    echo "Failed to mint token:" >&2
    jq . <<<"$create_response" >&2
    return 1
  fi

  minted_token="$(jq -r '.result.value' <<<"$create_response")"
  CF_MINTED_TOKEN_ID="$(jq -r '.result.id' <<<"$create_response")"
  CF_MINTED_TOKEN_EXPIRES="$expires_on"

  # R2's S3-compatible API accepts a Cloudflare API token directly as a
  # credential: access key id = token id, secret access key = sha256(token
  # value). See https://developers.cloudflare.com/r2/api/tokens/
  if command -v sha256sum >/dev/null 2>&1; then
    aws_secret_access_key="$(printf '%s' "$minted_token" | sha256sum | awk '{print $1}')"
  else
    aws_secret_access_key="$(printf '%s' "$minted_token" | shasum -a 256 | awk '{print $1}')"
  fi

  export TF_VAR_cloudflare_api_token="$minted_token"
  export AWS_ACCESS_KEY_ID="$CF_MINTED_TOKEN_ID"
  export AWS_SECRET_ACCESS_KEY="$aws_secret_access_key"
  export AWS_ENDPOINT_URL_S3="https://${CF_ACCOUNT_ID}.r2.cloudflarestorage.com"
  export AWS_REGION="auto"
  export AWS_DEFAULT_REGION="auto"

  cf_revoke_token() {
    if [[ -n "${CF_MINTED_TOKEN_ID:-}" ]]; then
      curl -sS -X DELETE -H "Authorization: Bearer $minter_token" \
        "$api/accounts/$CF_ACCOUNT_ID/tokens/$CF_MINTED_TOKEN_ID" >/dev/null \
        && echo "Revoked Cloudflare token $CF_MINTED_TOKEN_ID" >&2 \
        || echo "Warning: failed to revoke token $CF_MINTED_TOKEN_ID (it still expires at $CF_MINTED_TOKEN_EXPIRES)" >&2
      unset TF_VAR_cloudflare_api_token AWS_ACCESS_KEY_ID AWS_SECRET_ACCESS_KEY \
        AWS_ENDPOINT_URL_S3 AWS_REGION AWS_DEFAULT_REGION CF_MINTED_TOKEN_ID CF_MINTED_TOKEN_EXPIRES
    fi
    # Unconditional: also locks a BW_SESSION the caller had already passed
    # in, not just one this script unlocked itself.
    bw lock >/dev/null \
      && echo "Locked Bitwarden vault" >&2 \
      || echo "Warning: failed to lock Bitwarden vault" >&2
  }

  echo "Minted Cloudflare token '$token_name' (expires $expires_on)" >&2
  echo "  DNS:  Zone Read + DNS Write, all zones" >&2
  if [[ "$R2_ADMIN" == "1" ]]; then
    echo "  R2:   admin (create/delete/configure buckets), whole account" >&2
  else
    echo "  R2:   read/write on bucket '$CF_R2_BUCKET'" >&2
  fi
  echo "Exported: TF_VAR_cloudflare_api_token, AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_ENDPOINT_URL_S3" >&2

  if [[ $# -gt 0 ]]; then
    "$@"
    local exit_code=$?
    cf_revoke_token
    return "$exit_code"
  else
    trap cf_revoke_token EXIT
    echo "Run 'cf_revoke_token' to revoke and lock early, or it happens automatically when this shell exits (or the token expires at $expires_on)." >&2
  fi
}

if [[ "${BASH_SOURCE[0]:-$0}" != "$0" ]]; then
  _cf_mint_token_main "$@"
  unset -f _cf_mint_token_main
else
  _cf_mint_token_main "$@"
  exit $?
fi
