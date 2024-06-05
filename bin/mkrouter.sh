#!/bin/bash
# This will make your host a router
set -e

# check root
SELF=$(realpath "$0")
if [ "$EUID" -ne 0 ]; then
    echo "missing privileges, restarting using sudo"
    sudo $SELF $@
    exit
fi

sysctl net.ipv4.ip_forward=1
iptables -t nat -A POSTROUTING -j MASQUERADE
iptables -A FORWARD -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
