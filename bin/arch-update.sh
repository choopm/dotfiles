#!/bin/bash
# Way of updating your ArchLinux machine and removing unneeded packages.
# Mind you need to have pacman-contrib installed aswell.
# Caches are pruned to keep the latest 2 versions of any package.
set -e

sudo pacman -Syu
sudo pacman -Rscn $(pacman -Qtdq) || true
sudo paccache -rk2
sudo paccache -ruk0

paccache --cachedir $HOME/.cache/pikaur/pkg -rk2
paccache --cachedir $HOME/.cache/pikaur/pkg -ruk0

rm -rf $HOME/.local/share/Trash/files/*
killall -USR1 py3status || true
