#!/bin/sh

# This in need in case you need to re-run operations or do some manual checks
# You need to run this from host system you build from (ubuntu in most cases)

# umount tree (non-destructive)
umount -l -A -R -f /mnt/gentoo

cryptsetup close cryptroot

# destroy everything
lvremove -f /dev/mapper/vg-root
cryptsetup close lvm

parted /dev/sda rm 2
parted /dev/sda rm 1

# remove marks so we can re-run setupo script again from scratch
rm /etc/chef/.*.done
