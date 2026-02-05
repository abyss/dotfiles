#!/bin/bash
# shellcheck disable=SC1091,SC2088

__install_dotfiles() {
  # Where the install script is located
  local SCRIPTPATH; SCRIPTPATH="$( cd "$(dirname "$0")" || exit ; pwd -P )"

  # Load in Utility Helpers
  source "${SCRIPTPATH}"/util/helpers.sh

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
  ln -sfnv "${SCRIPTPATH}"/bin/* ~/bin/

  # symlink dotfiles from home/
  header 'Creating home dotfile symlinks'
  shopt -s dotglob  # Include hidden files in glob
  for item in "${SCRIPTPATH}"/home/*; do
    local basename; basename=$(basename "$item")

    # Skip if doesn't exist (empty glob)
    [ -e "$item" ] || continue

    if [ -f "$item" ]; then
      # Regular file - symlink it
      ln -sfnv "$item" ~/"$basename"
    elif [ -d "$item" ]; then
      # Directory - only handle .vim for now
      if [ "$basename" = ".vim" ]; then
        if [ -d ~/.vim ] && [ ! -L ~/.vim ]; then
          error "~/.vim exists and can't be symlinked. To use these settings, delete it and rerun this script."
        else
          ln -sfnv "$item" ~/.vim
        fi
      fi
    fi
  done

  # Check for .vimrc conflict
  if [ -e ~/.vimrc ]; then
    warning '~/.vimrc exists and will take precedence. To use these settings, delete it.'
  fi

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
  source "${SCRIPTPATH}"/util/git-config.sh

  # check if git config --global user.email / user.name are set
  local GIT_USER_NAME; GIT_USER_NAME=$(git config --global user.name)
  local GIT_USER_EMAIL; GIT_USER_EMAIL=$(git config --global user.email)

  if [ -z "$GIT_USER_NAME" ] || [ -z "$GIT_USER_EMAIL" ]; then
    warning 'You should run "git config --global user.name" and "git config --global user.email" to set your git user info'
  fi

  success 'Unless there are any errors above, installed successfully!'
  information 'Run "source ~/.bashrc" to see the changes.'
}

__install_dotfiles
