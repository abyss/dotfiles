### Modified Ubuntu .bashrc 2019-04-09
# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091,SC2155

# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"


# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    # shellcheck disable=SC2015
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
    if [ -f /usr/share/bash-completion/bash_completion ]; then
        . /usr/share/bash-completion/bash_completion
    elif [ -f /etc/bash_completion ]; then
        . /etc/bash_completion
    fi
fi

##### Custom Additions

if [ "$OSTYPE" = "msys" ]; then
    # When using Windows, FORCE_COLOR (mostly for node-chalk)
    # and setup the winpty aliases.

    export FORCE_COLOR=1
    alias node='winpty node.exe'
    alias python='winpty python.exe'
    alias py='winpty py.exe'
    alias php='winpty php.exe'
fi

if [ -s "/usr/local/bin/brew" ]; then
    # Mac OSX Intel
    export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"
fi

if [ -s "/opt/homebrew/bin/brew" ]; then
    # Mac OSX Arm
    # shellcheck disable=SC2155
    eval "$(/opt/homebrew/bin/brew shellenv)"
    export PATH="$(brew --prefix)/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/gawk/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/grep/libexec/gnubin:$PATH"
    export PATH="$(brew --prefix)/opt/gnu-sed/libexec/gnubin:$PATH"

    export BASH_COMPLETION_COMPAT_DIR="/opt/homebrew/etc/bash_completion.d"
    [[ -r "$(brew --prefix)/etc/profile.d/bash_completion.sh" ]] && . "$(brew --prefix)/etc/profile.d/bash_completion.sh"
fi

# NVM
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/local/opt/nvm/nvm.sh" ] && . "/usr/local/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/usr/local/opt/nvm/etc/bash_completion.d/nvm" ] && . "/usr/local/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

if [ "$OSTYPE" != "msys" ]; then
    # Homebrew NVM Versions
    [ -s "$(brew --prefix)/opt/nvm/nvm.sh" ] && . "$(brew --prefix)/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm" ] && . "$(brew --prefix)/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# System Specific, Non-Git Tracked Aliases
if [ -f ~/.system_aliases ]; then
    . ~/.system_aliases
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH" # ~/bin and ~/.local/bin in path

export EDITOR="vim" # default to Vim
export TENV_AUTO_INSTALL=true

source ~/bin/set-prompt.sh

# danielfoehrkn/switch/switch - Kubectx alternative
if [ -f /opt/homebrew/bin/switcher ]; then
    # shellcheck disable=SC1090
    source <(switcher init bash)
fi

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"
