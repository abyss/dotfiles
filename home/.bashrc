# shellcheck shell=bash
# shellcheck disable=SC1090,SC1091

# ~/.bashrc: executed by bash(1) for non-login shells.

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't save lines starting with a space, and drop earlier copies of a
# repeated command (erasedups supersedes ignoredups). See bash(1) for more.
HISTCONTROL=ignorespace:erasedups

# don't record navigation/listing noise. Each pattern must match the whole
# line, hence the separate 'ls *' alongside 'ls'.
HISTIGNORE='ls:ls *:ll:la:lll:pwd:clear:history:exit:..:...:....:.....:.2:.3:.4:.5:brc'

# append to the history file, don't overwrite it
shopt -s histappend

# unlimited history: -1 keeps every command and never truncates the file
HISTSIZE=-1
HISTFILESIZE=-1

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# enable color support of ls and also add handy aliases
if command -v dircolors >/dev/null; then
    # shellcheck disable=SC2015
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    # alias dir='dir --color=auto'
    # alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
fi

# Git Tracked Aliases
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

# Homebrew, if installed: macOS (Apple Silicon) or Linuxbrew.
# shellenv puts brew on PATH, so it has to run before brew is callable.
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

if command -v brew >/dev/null; then
    # Resolve once; every 'brew --prefix' call spawns a subprocess.
    BREW_PREFIX="$(brew --prefix)"

    # GNU userland ahead of the system defaults
    export PATH="$BREW_PREFIX/opt/coreutils/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/gawk/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/grep/libexec/gnubin:$PATH"
    export PATH="$BREW_PREFIX/opt/gnu-sed/libexec/gnubin:$PATH"

    export BASH_COMPLETION_COMPAT_DIR="$BREW_PREFIX/etc/bash_completion.d"
    [[ -r "$BREW_PREFIX/etc/profile.d/bash_completion.sh" ]] && . "$BREW_PREFIX/etc/profile.d/bash_completion.sh"
fi

# NVM
export NVM_DIR="$HOME/.nvm"

if [ -n "$BREW_PREFIX" ]; then
    # Homebrew-managed nvm
    [ -s "$BREW_PREFIX/opt/nvm/nvm.sh" ] && . "$BREW_PREFIX/opt/nvm/nvm.sh"  # This loads nvm
    [ -s "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm" ] && . "$BREW_PREFIX/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
fi

# System Specific, Non-Git Tracked Aliases
if [ -f ~/.system_aliases ]; then
    . ~/.system_aliases
fi

export PATH="$HOME/bin:$HOME/.local/bin:$PATH" # ~/bin and ~/.local/bin in path

export EDITOR="vim" # default to Vim
export TENV_AUTO_INSTALL=true

[ -r ~/bin/set-prompt.sh ] && source ~/bin/set-prompt.sh

# danielfoehrkn/switch/switch - Kubectx alternative
if command -v switcher >/dev/null; then
    source <(switcher init bash)
fi

[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"
