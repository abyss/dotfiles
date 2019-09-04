#!/bin/bash

__install_dotfiles() {
    local SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

    # Move all files from bin into ~/bin
    mkdir -p ~/bin
    cp -R ${SCRIPTPATH}/bin/* ~/bin

    ln -sfnv ${SCRIPTPATH}/.bash_aliases ~/.bash_aliases
    ln -sfnv ${SCRIPTPATH}/.bashrc ~/.bashrc
    ln -sfnv ${SCRIPTPATH}/.vim ~/.vim
}

__install_dotfiles

source ~/.bashrc
