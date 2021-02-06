#!/bin/bash

GIT_PS1_SHOWDIRTYSTATE=true
GIT_PS1_SHOWSTASHSTATE=true
GIT_PS1_SHOWUNTRACKEDFILES=true

source ~/bin/git-prompt.sh
source ~/bin/terraform-prompt.sh
source ~/bin/aws-prompt.sh

__set_bash_ps1() {
    local RESET='\[\033[0m\]'

    local RED='\[\033[00;31m\]'
    local GREEN='\[\033[00;32m\]'
    local YELLOW='\[\033[00;33m\]'
    local BLUE='\[\033[00;34m\]'
    local PURPLE='\[\033[00;35m\]'
    local CYAN='\[\033[00;36m\]'
    local LIGHTGRAY='\[\033[00;37m\]'
    local LRED='\[\033[01;31m\]'
    local LGREEN='\[\033[01;32m\]'
    local LYELLOW='\[\033[01;33m\]'
    local LBLUE='\[\033[01;34m\]'
    local LPURPLE='\[\033[01;35m\]'
    local LCYAN='\[\033[01;36m\]'
    local WHITE='\[\033[01;37m\]'

    local TITLE_START='\[\033]0;'
    local TITLE_END='\007\]'

    local USER='\u'
    local HOST='\h'
    local DIR='\w'
    local TIME='\t'

    local TERM_TITLE="${TITLE_START}${USER}@${HOST} ${DIR}${TITLE_END}"

    local HOST_PROMPT="${LPURPLE}${USER}${PURPLE}@${HOST}${RESET}"
    local DIR_PROMPT="${YELLOW}${DIR}${RESET}"

    # These need to be escaped so they don't evaluate the function on first load
    # however, the color codes do need to be evaluated
    local GIT_PROMPT="\$(__git_ps1 \"${CYAN}git:(${LCYAN}%s${CYAN})${RESET} \")"
    local TF_PROMPT="\$(__terraform_workspace \"${PURPLE}tf:(${LPURPLE}%s${PURPLE})${RESET} \")"
    local AWS_PROMPT="\$(__aws_profile \"${GREEN}aws:(${LGREEN}%s${GREEN})${RESET} \")"

    local PROMPT=$'\n'"${HOST_PROMPT} ${DIR_PROMPT} ${GIT_PROMPT}${TF_PROMPT}${AWS_PROMPT}"$'\n'"${WHITE}$ ${RESET}"

    PS1="${TERM_TITLE}${PROMPT}"
}

__set_bash_ps1
