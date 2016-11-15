with_marker_file :chroot_install_grub do
  execute 'USE=device-mapper chroot /mnt/gentoo emerge grub'
end
