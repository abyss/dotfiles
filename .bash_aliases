# shellcheck shell=bash
alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias lll='ls -lah'

alias df='df -H'

alias brc='source ~/.bashrc'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

alias lspath="tr ':' '\n' <<< \$PATH"

# git
alias git-changelog='git log --pretty="- %s"'

# ansible trust-all-hosts
alias ansible-hosts='ANSIBLE_HOST_KEY_CHECKING=false ansible all -m ping'

# setup node environments
alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

# aws cli
alias awsid='aws sts get-caller-identity'

# terraform and terragrunt
alias tg='terragrunt'
alias tfmt='terraform fmt -recursive'
alias tfi='tf init'
alias tfa='tf apply'
alias tfia='tf init && tf apply'
alias tfp='tf plan'
alias tfip='tf init && tf plan'
alias tfiu='tf init -upgrade'
alias tgu='tf get -update'
alias tfw='tf workspace'

# calling this twice fixes some edge cases...
alias tflock='terraform providers lock && terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=darwin_arm64 -platform=linux_amd64 -platform=linux_arm64'
# This one is for projects with the `template` provider. Not supported on M1 Mac
alias tflock-template='terraform providers lock && terraform providers lock -platform=windows_amd64 -platform=darwin_amd64 -platform=linux_amd64 -platform=linux_arm64'

# M1 Terraform Helper
alias m1-tf='m1-terraform-provider-helper install'
alias m1-lock='m1-terraform-provider-helper lockfile upgrade'

# Find Terraform Local States
alias tf-local-state='find . -type f -name "terraform.tfstate" -not -path "*/.terraform/*"'

# Version file requirement when using TF
tf () {
  if [ -f .opentofu-version ]; then
    tofu "$@"
  elif [ -f .terraform-version ]; then
    terraform "$@"
  else
    fortune ~/Code/abyss/fortune-failures/failures
    echo "(Missing .opentofu-version or .terraform-version file)"
    (exit 1)
  fi
}

# terraform workspace apply with var-file of same name
tfwsa () {
  local current_tf_workspace
  current_tf_workspace=$(terraform workspace show 2>/dev/null)
  tf "$@" -var-file "$current_tf_workspace.tfvars"
}

# tfdocs generate current folder
alias tfdoc-gen='terraform-docs markdown document ./ >README.md'

# Authenticate old versions of TF with AWS SSO
alias sso-tf-login='. ~/bin/sso-tf-login.sh'

# clean up after terraform - these files get big over time!
alias tf-clean='find . -name ".terraform" -type d -print0 | xargs -0 rm -rf'
alias ic-clean='find . -name ".infracost" -type d -print0 | xargs -0 rm -rf'

# Kubernetes
alias k='kubectl'

# Utility
alias ungron="gron --ungron"
