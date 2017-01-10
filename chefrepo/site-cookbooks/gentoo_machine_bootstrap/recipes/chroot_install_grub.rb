with_marker_file :chroot_install_grub do
  execute 'USE="device-mapper -thin" chroot /mnt/gentoo emerge --usepkg grub'
end
