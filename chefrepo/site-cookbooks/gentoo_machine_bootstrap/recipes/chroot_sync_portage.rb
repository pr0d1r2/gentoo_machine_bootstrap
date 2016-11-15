with_marker_file :chroot_sync_portage do
  execute 'chroot /mnt/gentoo emerge --sync'
end
