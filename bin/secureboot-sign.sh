#!/bin/bash
# I use this to create and sign my EFI stubs
# Usage: sudo secureboot-sign boot/vmlinuz-linux-hardened && sudo secureboot-sign boot/vmlinuz-linux

set -euxo pipefail

FILE=$(echo $1 | sed 's/boot\///')
TARGET=$(echo $FILE | sed 's/vmlinuz-//;s/initramfs-//;s/\.img//')
BOOTDIR=/boot
CERTDIR=/home/choopm/Syncthing/Archiv/Keys/SecureBoot
KERNEL="$BOOTDIR/vmlinuz-$TARGET"
INITRAMFS="/boot/intel-ucode.img /boot/initramfs-$TARGET.img"
EFISTUB=/usr/lib/systemd/boot/efi/linuxx64.efi.stub
OUTIMG=/boot/vmlinuz-$TARGET-signed.efi
CMDLINE=/boot/loader/entries/1-arch-vanilla.conf
SYSTEMDBOOT=/boot/EFI/systemd/systemd-bootx64.efi
SYSTEMDBOOTSTUB=/usr/lib/systemd/boot/efi/systemd-bootx64.efi
BUILDDIR=$(mktemp -d)

cat ${INITRAMFS} > ${BUILDDIR}/initramfs.img
cat ${CMDLINE} | grep options | cut -d' ' -f2- > ${BUILDDIR}/cmdline.txt

echo "==> Installing $SYSTEMDBOOTSTUB"
/usr/bin/sbsign --key ${CERTDIR}/DB.key --cert ${CERTDIR}/DB.crt --output ${BUILDDIR}/signed-systemd.efi ${SYSTEMDBOOTSTUB} 2>/dev/null
sudo cp ${BUILDDIR}/signed-systemd.efi ${SYSTEMDBOOT}
echo "==> Signed $SYSTEMDBOOT"

align="$(objdump -p ${EFISTUB} | awk '{ if ($1 == "SectionAlignment"){print $2} }')"
align=$((16#$align))
osrel_offs="$(objdump -h ${EFISTUB} | awk 'NF==7 {size=strtonum("0x"$3); offset=strtonum("0x"$4)} END {print size + offset}')"
osrel_offs=$((osrel_offs + "$align" - osrel_offs % "$align"))
cmdline_offs=$((osrel_offs + $(stat -Lc%s "/usr/lib/os-release")))
cmdline_offs=$((cmdline_offs + "$align" - cmdline_offs % "$align"))
initrd_offs=$((cmdline_offs + $(stat -Lc%s ${BUILDDIR}/cmdline.txt)))
initrd_offs=$((initrd_offs + "$align" - initrd_offs % "$align"))
linux_offs=$((initrd_offs + $(stat -Lc%s ${BUILDDIR}/initramfs.img)))
linux_offs=$((linux_offs + "$align" - linux_offs % "$align"))
objcopy \
    --add-section .osrel="/usr/lib/os-release" \
    --change-section-vma .osrel=$(printf 0x%x $osrel_offs) \
    --add-section .cmdline=${BUILDDIR}/cmdline.txt \
    --change-section-vma .cmdline=$(printf 0x%x $cmdline_offs) \
    --add-section .initrd=${BUILDDIR}/initramfs.img \
    --change-section-vma .initrd=$(printf 0x%x $initrd_offs) \
    --add-section .linux=${KERNEL} \
    --change-section-vma .linux=$(printf 0x%x $linux_offs) \
    ${EFISTUB} ${BUILDDIR}/combined-boot.efi

/usr/bin/sbsign --key ${CERTDIR}/DB.key --cert ${CERTDIR}/DB.crt --output ${BUILDDIR}/signed.efi ${BUILDDIR}/combined-boot.efi # 2>/dev/null
sudo cp ${BUILDDIR}/signed.efi ${OUTIMG}
echo "==> Signed $OUTIMG"
