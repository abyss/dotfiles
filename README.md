# Abyss' Dotfiles

My personal dotfiles repository. Feel free to modify for your own use.

## Setup

1) `git clone https://github.com/abyss/dotfiles.git`
2) `bash ./dotfiles/install.sh`
> **Warning:** this will remove your current `.bashrc`, `.vim`, and `.bash_aliases`

### What `install.sh` does
1) Create `~/bin` directory if it does not already exist.
2) Copy all files from `dotfiles/bin` into `~/bin`
3) Create a symlink for `.bash_aliases`, `.bashrc`, and `.vim` directory
