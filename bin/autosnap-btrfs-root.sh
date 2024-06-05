#!/bin/bash
# This will snapshot your btrfs rootfs subvolume to SNAPSDIR named
# using PREFIX-<date>. Adjust REVISIONS to auto-delete old snapshots.
# It also installs CRONFILE as a symlink to itself.

set -e

SNAPSDIR="/var/lib/btrfs/arch.snaps"
REVISIONS=3
PREFIX="autosnap"
CRONFILE=/etc/cron.daily/10_autosnap-btrfs-root

# prefix required
if [ -z "$PREFIX" ]; then
    echo "error: prefix can not be empty"
    exit
fi

# check root
SELF=$(realpath "$0")
if [ "$EUID" -ne 0 ]; then
    echo "missing privileges, restarting using sudo"
    sudo $SELF $@
    exit
fi

# install a cronjob
ln -sf ${SELF} ${CRONFILE}

# generate name based on date
NAME=$(date +"${PREFIX}-%Y-%m-%d")

# create read only snapshot if missing
if [ ! -d ${SNAPSDIR}/${NAME} ]; then
    btrfs subvolume snapshot -r / ${SNAPSDIR}/${NAME}
else
    echo "snapshot already exists: ${SNAPSDIR}/${NAME}"
fi

# prune old revisions
count="$(ls -d ${SNAPSDIR}/* | grep ${PREFIX} | wc -l)"
clip=$(( $count - $REVISIONS ))
if [ $clip -gt 0 ]; then
    echo "removing the oldest $clip snapshots"
	for sub in $(ls -d ${SNAPSDIR}/${PREFIX}* | head -n $clip)
	do
        btrfs subvolume delete "$sub"
	done
else
    echo "0 snapshots removed"
fi
