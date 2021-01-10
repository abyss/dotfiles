alias df='df -H'
alias ls='ls -F --color=auto'
alias ll='ls -hl'
alias la='ll -a'
alias lll='la'
alias brc='source ~/.bashrc'

alias ansible-hosts='ANSIBLE_HOST_KEY_CHECKING=false ansible all -m ping'

# setup node environments
alias node-dev='export NODE_ENV=development'
alias node-prod='export NODE_ENV=production'

# aws cli
alias awsid='aws sts get-caller-identity'
