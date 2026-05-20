#!/usr/bin/env bash
# This will push a desktop notification to the specified userid.
# The message is passed as arguments.
# This can be used as a PROGRAM in mdadm.conf

RUNASUID=1000

set -e

# restart as user <RUNASUID>
SELF=$(realpath "$0")
if [ "$EUID" -ne $RUNASUID ]; then
    su - $RUNASUID $SELF $@
    exit
fi

# setup env
export DISPLAY=":0"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$RUNASUID/bus"
export XDG_RUNTIME_DIR="/run/user/$RUNASUID"

# push notification
MSG="$(echo $@)"
notify-send -u critical mdadm-event $MSG
