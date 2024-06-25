#!/bin/bash
# Toggles connection state of a bluetooth device specified by argument 1.
# Argument 1 is the $OUTPUT_PART of py3status, e.g.: " Bose 60%"
# Uses bluetoothctl devices, info and connect/disconnect

set -e

if [ -z "$1" ]; then
    echo "missing py3status composite parameter. Usage $0 <\$OUTPUT_PART>"
    exit 1
fi

# removes special characters,
# trims leading/trailing whitespace + returns first word
ALIAS=$(echo $1 | tr -dc '[:alnum:] ' | awk '{$1=$1;print $1}')
if [ -z "$ALIAS" ]; then
    echo "device alias parsing failed"
    exit 1
fi

# get first matching device address
ADDRESS=$(bluetoothctl devices | grep $ALIAS | head -n 1 | cut -f2 -d " ")
if [ -z "$ADDRESS" ]; then
    echo "get device address using alias failed"
    exit 1
fi

# connect/disconnect
if (bluetoothctl info $ADDRESS | grep "Connected: yes"); then
    bluetoothctl disconnect $ADDRESS
else
    bluetoothctl connect $ADDRESS
fi

# update status
killall -USR1 py3status
