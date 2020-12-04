#!/bin/sh
DATE=$(date +"%Y-%m-%d-%H%M%S")
FILE=~/Syncthing/Bilder/Screenshots/$DATE.png

if [ "$1" = "slurp" ]; then
  grim -g "$(slurp)" $FILE
else
  grim $FILE
fi
ln -sf $FILE ~/latest-scrot.png
wl-copy -t image/png <~/latest-scrot.png

# vim: set ts=2 sw=2 tw=0 et :
