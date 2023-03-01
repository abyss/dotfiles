#!/bin/bash
# Needs to be sourced to work due to unset and export commands

# Clear up old sessions so the JQ commands work
rm -rf ~/.aws/cli/
rm -rf ~/.aws/sso/
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
unset AWS_SESSION_TOKEN

aws sso login

# Needed to get the tokens in Cache
aws sts get-caller-identity > /dev/null

# Save the authentication tokens from SSO Cache
AWS_ACCESS_KEY_ID=$(jq -r .Credentials.AccessKeyId ~/.aws/cli/cache/*.json)
export AWS_ACCESS_KEY_ID

AWS_SECRET_ACCESS_KEY=$(jq -r .Credentials.SecretAccessKey ~/.aws/cli/cache/*.json)
export AWS_SECRET_ACCESS_KEY

AWS_SESSION_TOKEN=$(jq -r .Credentials.SessionToken ~/.aws/cli/cache/*.json)
export AWS_SESSION_TOKEN
