#!/bin/bash

LINUX="${1:-linux}"
INITRAMFS="/boot/initramfs-$LINUX.img"
KERNEL="/boot/vmlinuz-$LINUX"
LUKS="root"
KEYFILE="/home/choopm/Dokumente/KEY/kexec-luks-small.key"

umask 0077
CRYPTROOT_TMPDIR="$(mktemp -d --tmpdir=/dev/shm)"
INITRD="${CRYPTROOT_TMPDIR}/initramfs.img"
ROOTFS="$CRYPTROOT_TMPDIR/rootfs"
FILENAME="etc/crypto_keyfile.bin"
CMDLINE="$(cat /proc/cmdline)"
KVERSION=$(file $KERNEL | sed -r 's/.*version ([^ ]*).*/\1/')
mkdir -p $ROOTFS

cleanup() {
    shred -fu "$ROOTFS/$FILENAME" || true
    shred -fu "$INITRD" || true
    rm -rf "${CRYPTROOT_TMPDIR}"
}
trap cleanup INT TERM EXIT

cd "${ROOTFS}"
cat "${INITRAMFS}" | gzip -cd | cpio --quiet -i

cp $KEYFILE $FILENAME
sed -i 's/pkcs11-uri=[^, ]*//' etc/crypttab

find . | cpio --quiet -H newc -o | gzip >> "$INITRD"

cd /

echo "==> Loaded kernel $KVERSION, use: systemctl kexec to reboot"
/usr/bin/kexec -l "$KERNEL" --initrd="$INITRD" --command-line="$CMDLINE"

