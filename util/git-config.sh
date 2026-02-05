#!/bin/bash

# Convert CRLF to LF on Commit
printf "git config --global core.autocrlf input\n"
git config --global core.autocrlf input

# Global .gitignore File provided by this repository
printf "git config --global core.excludesfile ~/.gitignore_global\n"
git config --global core.excludesfile ~/.gitignore_global

# 'main' should be the default branch from now on
printf "git config --global init.defaultBranch main\n"
git config --global init.defaultBranch main

# Don't automatically merge on diverged pull. I'll deal with those manually.
printf "git config --global pull.ff only\n"
git config --global pull.ff only

# Git Aliases
printf "Configuring git aliases:\n"
printf "  - co → checkout\n"
git config --global alias.co checkout

printf "  - br → branch\n"
git config --global alias.br branch

printf "  - ci → commit\n"
git config --global alias.ci commit

printf "  - st → status\n"
git config --global alias.st status

printf "  - last → log -1 HEAD\n"
git config --global alias.last 'log -1 HEAD'

printf "  - unstage → reset HEAD --\n"
git config --global alias.unstage 'reset HEAD --'

printf "  - log-tree → a nicely formatted git log graph\n"
git config --global alias.log-tree '!git log --graph --abbrev-commit --decorate --date=relative --format=format:"%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(bold black)[%an]%C(reset)%C(bold yellow)%d%C(reset)" --all'
