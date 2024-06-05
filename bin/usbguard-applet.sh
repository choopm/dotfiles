#!/bin/sh
# Attaches to usbguards dbus and waits for events to be printed
# whenever a device is blocked.
# By providing argument 'allow' or 'reject' one can react to the latest event.

# check root
SELF=$(realpath "$0")
if [ "$EUID" -ne 0 ]; then
    echo "missing privileges, restarting using sudo"
    sudo $SELF $@
    exit
fi


listen() {
    dbus-monitor --system --profile "interface='org.usbguard.Devices1'" |
        while read -r line; do
            blocked="$(usbguard list-devices -b | head -n1 | grep -Po 'name "\K[^"]+')"
            if [ -n "$blocked" ]; then
                printf '  %s\n' "$blocked"
            else
                printf '\n'
            fi
        done
}

allow() {
    blocked_id="$(usbguard list-devices -b | head -n1 | grep -Po '^[^:]+')"
    usbguard allow-device "$blocked_id"
}

reject() {
    blocked_id="$(usbguard list-devices -b | head -n1 | grep -Po '^[^:]+')"
    usbguard reject-device "$blocked_id"
}

if [ "$1" = "allow" ]; then
    allow
elif [ "$1" = "reject" ]; then
    reject
else
    listen
fi
