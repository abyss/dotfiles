# Abyss' Dotfiles

My personal dotfiles repository. Feel free to modify for your own use.

## Setup

1) `git clone https://github.com/abyss/dotfiles.git`
2) `bash ./dotfiles/install.sh`
> **Warning:** this will remove your current `.bashrc`, `.vim`, and `.bash_aliases`

### What `install.sh` does
1) Create `~/bin` directory if it does not already exist.
2) Symlink all files in `dotfiles/bin` into `~/bin`
3) Symlink `.bash_aliases` and `.bashrc`
4) Symlink `.vim` directory
5) Create `~/.system_aliases` if it does not already exist
6) Configure git globally to the settings in `install.sh`
