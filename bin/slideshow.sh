#!/bin/bash
# This will pick a random .jpg file from a path specified as first argument
# and set it as a background image using swaymsg on all outputs.
# Then it symlinks the image to a path specified in second argument
# to be used with swaylock for example.
set -e

if [ -z "$1" ] || ! [ -d "$1" ] || [ -z "$2" ]; then
    echo "usage: $0 <path> <symlink-to>"
    exit
fi

# find $1 -type f -name "*.jpg" -print0 | shuf -n1 -z | xargs -0 feh
IMG=$(find $1 -type f -name "*.jpg" | shuf -n1)

ln -sf "$IMG" "$2"
swaymsg output "*" bg "$2" fit

echo "\"$IMG\""
