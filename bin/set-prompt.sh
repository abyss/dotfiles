#!/bin/bash

source ~/bin/git-prompt.sh

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

    local GIT_PROMPT='$(__git_ps1 "(%s) ")'

    local TERM_TITLE="${USER}@${HOST} ${DIR}"
    local PROMPT="${LPURPLE}${USER}${PURPLE}@${HOST} ${YELLOW}${DIR} ${CYAN}${GIT_PROMPT}${RESET}$"

    export PS1="${TITLE_START}${TERM_TITLE}${TITLE_END}${PROMPT} "
}

__set_bash_ps1
