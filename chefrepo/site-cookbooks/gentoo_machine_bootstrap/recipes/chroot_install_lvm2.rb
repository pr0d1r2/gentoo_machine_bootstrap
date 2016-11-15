with_marker_file :chroot_install_lvm2 do
  execute 'USE=-thin chroot /mnt/gentoo emerge lvm2'
end
