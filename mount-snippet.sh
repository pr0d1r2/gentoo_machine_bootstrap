#!/bin/sh

# Use it to mount already finished installation

cryptsetup luksOpen /dev/sda2 root
mkdir /mnt/gentoo
mount /dev/mapper/root /mnt/gentoo/
mount --rbind /dev/ /mnt/gentoo/dev/
mount --rbind /sys/ /mnt/gentoo/sys/
mount --rbind /run /mnt/gentoo/run/
mount proc -t proc /mnt/gentoo/proc/
mount tmpfs -t tmpfs /mnt/gentoo/tmp/
