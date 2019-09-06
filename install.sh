#!/bin/bash

__install_dotfiles() {
    local SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

    # Colors for output
    local RESET='\033[0m'
    local RED='\033[00;31m'
    local GREEN='\033[00;32m'
    local YELLOW='\033[00;33m'
    local BLUE='\033[00;34m'
    local PURPLE='\033[00;35m'
    local CYAN='\033[00;36m'
    local LIGHTGRAY='\033[00;37m'
    local LRED='\033[01;31m'
    local LGREEN='\033[01;32m'
    local LYELLOW='\033[01;33m'
    local LBLUE='\033[01;34m'
    local LPURPLE='\033[01;35m'
    local LCYAN='\033[01;36m'
    local WHITE='\033[01;37m'

    printf "${CYAN}### ${LCYAN}Creating ~/bin${RESET}\n"

    if [ ! -d ~/bin ]; then
        # bin isn't a directory
        if [ -e ~/bin ]; then
            # bin does exist though
            printf "${RED}!!! ~/bin exists and is not a directory. Terminating.${RESET}\n"
            exit 1
        else
            # bin doesn't exist, create it
            mkdir -vp ~/bin
        fi
    else
        printf "~/bin already directory, skipping\n"
    fi

    # Move all files from bin into ~/bin
    printf "${CYAN}### ${LCYAN}Creating all ~/bin symlinks${RESET}\n"
    ln -sfnv ${SCRIPTPATH}/bin/* ~/bin/

    printf "${CYAN}### ${LCYAN}Creating bash symlinks${RESET}\n"
    ln -sfnv ${SCRIPTPATH}/.bash_aliases ~/.bash_aliases
    ln -sfnv ${SCRIPTPATH}/.bashrc ~/.bashrc

    printf "${CYAN}### ${LCYAN}Creating vim symlink${RESET}\n"
    ln -sfnv ${SCRIPTPATH}/.vim ~/.vim

    printf "${CYAN}### ${LCYAN}Creating ~/.system_aliases${RESET}\n"

    if [ ! -f ~/.system_aliases ]; then
        echo "# Put system specific bash aliases here. They will not be tracked in git." > ~/.system_aliases
        printf "created ~/.system_aliases\n"
    else
        printf "~/.system_aliases already exists, skipping\n"
    fi

    printf "${CYAN}!!! ${GREEN}Unless there are any errors above, installed successfully! ${CYAN}!!!${RESET}\n"
    printf "${CYAN}### ${GREEN}Run \"source ~/.bashrc\" to see the changes.${RESET}\n"
}

__install_dotfiles
