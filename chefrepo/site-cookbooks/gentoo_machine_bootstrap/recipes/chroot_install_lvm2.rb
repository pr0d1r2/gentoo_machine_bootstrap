with_marker_file :chroot_install_lvm2 do
  execute 'chroot /mnt/gentoo emerge virtual/libudev' do
    only_if { node[:gentoo][:release] == 'vanilla' }
  end

  execute 'USE="device-mapper -thin" chroot /mnt/gentoo emerge --usepkg lvm2'
end
