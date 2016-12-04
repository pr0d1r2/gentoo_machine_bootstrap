with_marker_file :chroot_systemd do
  execute 'USE="cryptsetup" chroot /mnt/gentoo emerge systemd'

  execute 'systemd-machine-id-setup'

  execute "hostnamectl set-hostname #{node[:hostname]}"

  execute '/usr/lib/systemd/system-generators/systemd-cryptsetup-generator'

  execute "mv '/mnt/gentoo/tmp/systemd-cryptsetup@root.service' /mnt/gentoo/etc/systemd/system/"

  # TODO: not working (!?)
  # execute "chroot /mnt/gentoo sysctl enable '/tmp/systemd-cryptsetup@root.service'"

  execute "echo 'root #{node[:system_disk][:device_by_id]}' > /mnt/gentoo/etc/crypttab"
end
