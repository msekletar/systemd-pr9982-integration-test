#!/bin/bash
set -e

cryptdev="/dev/$(lsblk -n -o NAME,SIZE | grep 100M | awk '{print $1}')"
keydev="/dev/$(lsblk -n -o NAME,SIZE | grep 10M | awk '{print $1}')"

# install cryptsetup
dnf install -y cryptsetup

# setup crypt device
echo -n redhat | cryptsetup --batch-mode --force-password luksFormat "$cryptdev" -

# setup ext2 filesystem and write the keyfile
mkfs.ext2 -F -L KEYDEV "$keydev"
mkdir -p /mnt/keydev
mount -L KEYDEV /mnt/keydev
echo -n redhat > /mnt/keydev/key
chmod 0400 /mnt/keydev/key
umount /mnt/keydev

# setup kernel command line
uuid=$(lsblk -n -o UUID "$cryptdev")
grubby --update-kernel=$(grubby --default-kernel) --args="rd.luks.uuid=$uuid"
grubby --update-kernel=$(grubby --default-kernel) --args="rd.luks.key=$uuid=/key:LABEL=KEYDEV"

# update systemd
cat > /etc/yum.repos.d/systemd-cryptsetup-keydev-msekleta.repo <<EOF
[sd-cryptsetup-msekleta]
name=sd-cryptsetup-msekleta
baseurl=https://msekleta.fedorapeople.org/systemd-cryptsetup-keydev/
enabled=1
gpgcheck=0
EOF
dnf update -y systemd

# make sure we have updated systemd-cryptsetup-generator in initrd
dracut -f
