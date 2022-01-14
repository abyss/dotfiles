alias ls='ls -F --color=auto'
alias ll='ls -lh'
alias la='ls -lah'
alias lll='ls -lah'

alias df='df -H'

alias brc='source ~/.bashrc'

alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../..'
alias ....='cd ../../../..'
alias .....='cd ../../../..'
alias .2='cd ../..'
alias .3='cd ../../..'
alias .4='cd ../../../..'
alias .5='cd ../../../../..'

# ansible trust-all-hosts
alias ansible-hosts='ANSIBLE_HOST_KEY_CHECKING=false ansible all -m ping'

# setup node environments
alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

# aws cli
alias awsid='aws sts get-caller-identity'

# terraform and terragrunt
alias tg='terragrunt'

# .terraform-version file requirement when running tf
tf() {
    if [ ! -f .terraform-version ]; then
        echo "You fell victim to one of the classic blunders!"
        echo "(Missing .terraform-version file)"
        (exit 1)
    else
        terraform $@
    fi
}

# terraform workspace apply with var-file of same name
tfws () {
  local current_tf_workspace=$(terraform workspace show 2>/dev/null)
  tf "$@" -var-file $current_tf_workspace.tfvars
}

# tfdocs generate current folder
alias tfdoc-gen='terraform-docs markdown document ./ >README.md'

# tflint for modules
alias tflint-mod='tflint --config=$HOME/.tflint.module.hcl'

# Kubernetes
alias k='kubectl'
