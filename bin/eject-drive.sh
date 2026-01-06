#!/bin/bash
# Safely unmounts, ejects and powers off an external drive for removal

# usage
if [ -z "$1" ]; then
    echo "usage: $0 /dev/sda1"
    exit
fi

# check root
SELF=$(realpath "$0")
if [ "$EUID" -ne 0 ]; then
    echo "missing privileges, restarting using sudo"
    sudo $SELF $@
    exit
fi

sync
umount -lr $1
eject $1
udisksctl power-off -b $1
