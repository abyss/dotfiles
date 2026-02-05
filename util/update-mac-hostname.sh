#!/bin/bash

sudo scutil --set HostName "$1"
sudo scutil --set LocalHostName "$1"
sudo scutil --set ComputerName "$1"
dscacheutil -flushcache
echo "Hostname updated to $1. Please reboot the system for all changes to take effect."
