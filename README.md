# Abyss' Dotfiles

My personal dotfiles repository. Feel free to modify for your own use.

## If you want to use this, and you are not me

If you intend to use this as a template for your dotfiles, and you are not me, I strongly suggest you do the following things to personalize it.

1) :star: [this repo](https://github.com/abyss/dotfiles) on GitHub!
2) **Replace the authorized_keys with your own authorized_keys.**
3) *(Optional)* Inside `install.sh`, change the git config options
4) *(Optional)* Change any other files to your liking.

## Setup

1) `git clone https://github.com/abyss/dotfiles.git`
2) `bash ./dotfiles/install.sh`
> **Warning:** this will remove your current `.bashrc`, `.vim`, and `.bash_aliases`

## Updating

Most updates only need a `git pull`.

Changes to git config options or install process may be updated by executing `install.sh` again.

## Additional Notes
1) The `~/bin` directory will be created if it does not already exist.
2) `.bash_aliases` and `.bashrc` will be symlinked.
3) `.vim` will be symlinked.
4) `~/.system_aliases` will be created if it does not already exist. You can put system-specific aliases here that you do not want to be tracked by git.
5) git config global options are configured inside of `install.sh`, rather than by file.
6) `install.sh` should be able to be run multiple times with no bad side effects.
7) The `.ssh` directory includes an authorized_keys, but it is not managed automatically.
8) **On Git Bash for Windows:** The symlinks will likely not work, the files will be copied instead. Run `install.sh` to force update the files.
