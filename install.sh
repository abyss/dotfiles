#!/bin/bash

__install_dotfiles() {
  # Where the install script is located
  local SCRIPTPATH="$( cd "$(dirname "$0")" ; pwd -P )"

  # Load in Utility Helpers
  source ${SCRIPTPATH}/util/helpers.sh

  header 'Creating ~/bin'

  if [ ! -d ~/bin ]; then
    # bin isn't a directory
    if [ -e ~/bin ]; then
      # bin does exist though
      fail '~/bin exists and is not a directory. Terminating.'
      exit 1
    else
      # bin doesn't exist, create it
      mkdir -vp ~/bin
    fi
  else
    printf '~/bin already directory, skipping\n'
  fi

  # symlink bin files
  header 'Creating all ~/bin symlinks'
  ln -sfnv ${SCRIPTPATH}/bin/* ~/bin/

  # symlink bash files
  header 'Creating bash symlinks'
  ln -sfnv ${SCRIPTPATH}/.bash_aliases ~/.bash_aliases
  ln -sfnv ${SCRIPTPATH}/.bashrc ~/.bashrc

  # symlink vim files
  header 'Creating vim symlink'
  if [ -d ~/.vim ] && [ ! -L ~/.vim ]; then
    error "~/.vim exists and can't be symlinked. To use these settings, delete it and rerun this script."
  else
    ln -sfnv ${SCRIPTPATH}/.vim ~/.vim
  fi

  if [ -e ~/.vimrc ]; then
    warning '~/.vimrc exists and will take precedence. To use these settings, delete it.'
  fi

  # symlink terraform files
  ln -sfnv ${SCRIPTPATH}/.tflint.hcl ~/.tflint.hcl

  # create ~/.system_aliases if it doesn't exist
  header 'Creating ~/.system_aliases'

  if [ ! -f ~/.system_aliases ]; then
    echo "# Put system specific bash aliases here. They will not be tracked in git." > ~/.system_aliases
    printf "created ~/.system_aliases\n"
  else
    printf "~/.system_aliases already exists, skipping\n"
  fi

  # set git config --global options
  header 'git config options'
  source ${SCRIPTPATH}/util/git-config.sh

  # symlink global gitignore file
  ln -sfnv ${SCRIPTPATH}/linked.gitignore ~/.gitignore

  # check if git config --global user.email / user.name are set
  local GIT_USER_NAME=`git config --global user.name`
  local GIT_USER_EMAIL=`git config --global user.email`
  if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
    warning 'You should run "git config --global user.name" and "git config --global user.email" to set your git user info'
  fi

  success 'Unless there are any errors above, installed successfully!'
  information 'Run "source ~/.bashrc" to see the changes.'
}

__install_dotfiles
