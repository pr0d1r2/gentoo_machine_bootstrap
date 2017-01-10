with_marker_file :chroot_prepare_kernel_gentoo_sources do
  execute 'USE="symlink" chroot /mnt/gentoo emerge gentoo-sources'
end

with_marker_file :chroot_prepare_kernel_genkernel do
  if node[:gentoo][:release] == 'systemd'
    execute 'USE="cryptsetup" chroot /mnt/gentoo emerge --usepkg genkernel-next'
  else
    execute 'USE="cryptsetup" chroot /mnt/gentoo emerge --usepkg genkernel'
  end

  genkernel_use 'OLDCONFIG="no"'
  genkernel_use 'CLEAN="no"'
  genkernel_use 'MRPROPER="no"'
  genkernel_use 'LUKS="yes"'
  genkernel_use 'DISKLABEL="yes"'
  genkernel_use 'BOOTLOADER="grub2"'
  genkernel_use 'MAKEOPTS="-j' + `nproc`.strip + '"'
  genkernel_use 'ZFS="no"'
  genkernel_use 'BTRFS="no"'

  genkernel_use 'UDEV="yes"' do
    only_if { node[:gentoo][:release] == 'systemd' }
  end
end

with_marker_file :chroot_prepare_kernel_config do
  execute 'chroot /mnt/gentoo/ make -C /usr/src/linux olddefconfig'

  kernel_enable 'CONFIG_DM_CRYPT'
  kernel_enable 'CONFIG_CRYPTO'
  kernel_enable 'CONFIG_CRYPTO_CBC'
  kernel_enable 'CONFIG_CRYPTO_SHA256'
  kernel_enable 'CONFIG_CRYPTO_SHA512'
  kernel_enable 'CONFIG_CRYPTO_XTS'
  kernel_enable 'CONFIG_CRYPTO_AES_X86_64'
  kernel_enable 'CONFIG_CRYPTO_AES_NI_INTEL'
  kernel_enable 'CONFIG_USB_XHCI_HCD' if node[:system_disk][:usb]

  [node[:hardware]].flatten.compact.each do |hardware|
    include_recipe "hardware::#{hardware}"
  end

  if node[:gentoo][:release] == 'systemd'
    kernel_enable 'CONFIG_FHANDLE'
    kernel_enable 'CONFIG_CGROUPS'
    kernel_enable 'CONFIG_GENTOO_LINUX_INIT_SYSTEMD'
    kernel_enable 'CONFIG_EXPERT'
    kernel_enable 'CONFIG_EPOLL'
    kernel_enable 'CONFIG_SIGNALFD'
    kernel_enable 'CONFIG_TIMERFD'
    kernel_enable 'CONFIG_EVENTFD'
    kernel_enable 'CONFIG_NET'
    kernel_enable 'CONFIG_DEVTMPFS'
    kernel_enable 'CONFIG_INOTIFY_USER'
    kernel_enable 'CONFIG_PROC_FS'
    kernel_enable 'CONFIG_SYSFS'
    # UEFI
    kernel_enable 'CONFIG_PARTITION_ADVANCED'
    kernel_enable 'CONFIG_EFI_PARTITION'
    kernel_enable 'CONFIG_EFI'
    kernel_enable 'CONFIG_EFI_VARS'
  end

  execute 'chroot /mnt/gentoo/ make -C /usr/src/linux olddefconfig'
end

with_marker_file :chroot_prepare_kernel_build do
  if node[:testing_on_travis]
    execute 'chroot /mnt/gentoo genkernel all --loglevel=4' do
      live_stream true
    end
  else
    execute 'chroot /mnt/gentoo genkernel all'
  end
end
