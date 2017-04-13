# gentoo_machine_bootstrap [![Build Status](https://travis-ci.org/pr0d1r2/gentoo_machine_bootstrap.svg?branch=master)](https://travis-ci.org/pr0d1r2/gentoo_machine_bootstrap)

Initialize machine booted with linux to prepare Gentoo Linux
installation on it.

Prepares on remote machine:

- Chef-DK on remote machine base system
- partitions on disk
- Gentoo rootfs with portage
- Chef-DK on Gentoo rootfs

## setup

Create minimal host config. For example if your machine IP address is
192.168.88.88 create `nodes/192.168.88.88.json` file containing
something like:

```
{
  "run_list": [
    "gentoo_machine_bootstrap"
  ],
  "arch": "x86_64",
  "system_disk": {
    "usb": true,
    "device_by_id": "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_50E666C84720B06571EA10EA-0:0"
  },
  "hostname": "storage",
  "hardware": [
    "asrock_rack_c2750d4i"
  ],
  "network_devices": [
    "enp7s0",
    "enp8s0"
  ],
  "automatic": {
    "ipaddress": "192.168.88.88"
  }
}
```

Then if you boot your machine from ubuntu Live CD (I use Ubuntu 16.04
desktop 64 net-booted from OpenWRT using [openwrt_tools](https://github.com/pr0d1r2/openwrt_tools/blob/master/setup_pxe_boot_ubuntu_16_04_desktop_64.sh)).

After boot you need to:
- change `ubuntu` user password
- install SSH server via `apt-get install openssh-server`

After all that simply run:

```
sh setup_ubuntu.sh 192.168.1.119
```

Wait for first failure and follow instructions.
