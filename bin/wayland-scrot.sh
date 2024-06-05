#!/bin/sh
# Creates desktop screenshots in DST and updates symlink SYM
# to always refer to the latest scrot. Aferwards the image
# is copied to clipboard.
# Providing argument "slurp" will let you select an area to capture.

DST="$HOME/Syncthing/Bilder/Screenshots"
DATE="$(date +"%Y-%m-%d-%H%M%S")"
FILE="${DST}/$DATE.png"
SYM="$HOME/latest-scrot.png"

if [ "$1" = "slurp" ]; then
  grim -g "$(slurp)" ${FILE}
else
  grim ${FILE}
fi
ln -sf ${FILE} ${SYM}
wl-copy -t image/png <${SYM}
