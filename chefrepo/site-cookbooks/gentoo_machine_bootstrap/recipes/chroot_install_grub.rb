with_marker_file :chroot_install_grub do
  directory '/mnt/gentoo/usr/portage/packages'
  directory '/mnt/gentoo/usr/portage/packages/sys-boot'

  remote_file '/mnt/gentoo/usr/portage/packages/sys-boot/grub-2.02_beta3-r1.tbz2' do
    source "#{node[:gentoo][:pkg_source]}/grub-2.02_beta3-r1.tbz2"
    checksum '01f3ea857c530f0a579d42079c3fd5cc7851acfd924d99779fbaea45c56846ba'
  end

  execute 'USE="device-mapper -thin" chroot /mnt/gentoo emerge --usepkgonly grub'
end
