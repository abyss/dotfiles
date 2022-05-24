#!/bin/bash

# Convert CRLF to LF on Commit
printf "git config --global core.autocrlf input\n"
git config --global core.autocrlf input

# Global .gitignore File provided by this repository
printf "git config --global core.excludesfile ~/.gitignore\n"
git config --global core.excludesfile ~/.gitignore

# 'main' should be the default branch from now on
printf "git config --global init.defaultBranch main\n"
git config --global init.defaultBranch main

# Don't automatically merge on diverged pull. I'll deal with those manually.
printf "git config --global pull.ff only\n"
git config --global pull.ff only
