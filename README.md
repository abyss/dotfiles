![License: MIT](https://img.shields.io/github/license/abyss/dotfiles?style=for-the-badge)
![Uses git](https://img.shields.io/badge/uses-git-blue?style=for-the-badge)
![Works on my machine](https://img.shields.io/badge/works%20on-my%20machine-red?style=for-the-badge)

# Abyss' Dotfiles

My personal dotfiles repository. Feel free to modify for your own use.

## Repository Structure

This repository is organized into distinct directories based on their purpose:

- **`home/`** - Configuration files (dotfiles) that get symlinked into `$HOME`. This includes shell configs (`.bashrc`, `.bash_aliases`), editor configs (`.vim`), tool-specific configs (`.tflint.hcl`, `.gitignore_global`), and package management (`Brewfile`).

- **`bin/`** - Executable scripts that get symlinked into `~/bin` and added to your `$PATH`. These are user-facing tools you can run from anywhere in your shell.

- **`util/`** - Utility scripts that support the dotfiles infrastructure but are NOT linked into `~/bin`. These include installation helpers (`helpers.sh`, `git-config.sh`) and standalone utilities that you run directly from the repo (like `update-mac-hostname.sh`).

- **Root files** - Installation (`install.sh`), documentation (`README.md`), and project metadata (`LICENSE`, `.editorconfig`).

## If you want to use this, and you are not me

If you intend to use this as a template for your dotfiles, and you are not me, I strongly suggest you do the following things to personalize it.

1) :star: [this repo](https://github.com/abyss/dotfiles) on GitHub!
2) **Remove or replace the authorized_keys with your own authorized_keys.** *These aren't installed by the script, they only exist for manual copying.*
3) *(Optional)* Inside `install.sh`, change the git config options.
4) *(Optional)* Change any other files to your liking.

## Setup

1) `git clone https://github.com/abyss/dotfiles.git`
2) *(Optional)* On Windows, see [Getting symlinks to work on Windows](#getting-symlinks-to-work-on-windows).
3) `bash ./dotfiles/install.sh`
> **Warning:** this will remove your current `~/.bashrc`, `~/.vim`, `~/.bash_aliases`, `~/.tflint.hcl`, `~/.gitignore_global`, and `~/Brewfile`.
4) *(Optional)* On MacOS, `brew bundle` will install the `~/Brewfile` contents.

## Updating

Any existing files will be updated by a `git pull`.

Creation of new files, changes to git config options, and install process may be updated by executing `install.sh` again.

## Getting symlinks to work on Windows

If you are running the install on Windows, the symlinks will not work out of the box. To fix this, you need to do two things:

1) Run Git Bash as Administrator
2) Set the following environment variable first: `export MSYS=winsymlinks:nativestrict`

## Additional Notes
1) The `~/bin` directory will be created if it does not already exist.
2) All files in `home/` will be symlinked into your home directory.
3) `~/.system_aliases` will be created if it does not already exist. You can put system-specific aliases here that you do not want to be tracked by git.
4) git config global options are configured inside of `install.sh`, rather than by file.
5) `install.sh` should be able to be run multiple times with no bad side effects.
6) The `.ssh` directory includes an authorized_keys, but it is not managed automatically.
