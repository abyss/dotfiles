#!/bin/bash
# inspiration / partial credit: https://github.com/amatellanes/terraform-workspace-prompt

__terraform_workspace() {
    # preserve exit status
    local exit=$?

    if [ -f .terraform/environment ]; then
        local workspace
        workspace="$(cat .terraform/environment)"
        # shellcheck disable=SC2059
        printf "$1" "${workspace}"
    fi

    return $exit
}
