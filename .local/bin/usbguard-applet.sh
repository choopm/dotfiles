#!/bin/sh


listen() {
    sudo dbus-monitor --system --profile "interface='org.usbguard.Devices1'" |
        while read -r line; do
            blocked="$(sudo usbguard list-devices -b | head -n1 | grep -Po 'name "\K[^"]+')"
            if [ -n "$blocked" ]; then
                printf '  %s\n' "$blocked"
            else
                printf '\n'
            fi
        done
}

allow() {
    blocked_id="$(sudo usbguard list-devices -b | head -n1 | grep -Po '^[^:]+')"
    sudo usbguard allow-device "$blocked_id"
}

reject() {
    blocked_id="$(sudo usbguard list-devices -b | head -n1 | grep -Po '^[^:]+')"
    sudo usbguard reject-device "$blocked_id"
}

if [ "$1" = "allow" ]; then
    allow
elif [ "$1" = "reject" ]; then
    reject
else
    listen
fi

