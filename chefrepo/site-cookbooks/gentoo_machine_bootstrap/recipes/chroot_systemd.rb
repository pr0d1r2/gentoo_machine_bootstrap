with_marker_file :chroot_systemd do
  execute 'USE="cryptsetup" chroot /mnt/gentoo emerge systemd'

  execute 'systemd-machine-id-setup'

  execute '/usr/lib/systemd/system-generators/systemd-cryptsetup-generator'
end
