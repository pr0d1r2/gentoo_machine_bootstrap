with_marker_file :chroot_install_lvm2 do
  directory '/mnt/gentoo/usr/portage/packages'
  directory '/mnt/gentoo/usr/portage/packages/sys-fs'

  remote_file '/mnt/gentoo/usr/portage/packages/sys-fs/lvm2-2.02.116-r4.tbz2' do
    source "#{node[:gentoo][:pkg_source]}/lvm2-2.02.116-r4.tbz2"
    checksum 'ff97b4f61ed74eced430ba4b65c665f816cbc03e558d74d95edbad4cfc044369'
  end

  execute 'USE="device-mapper -thin" chroot /mnt/gentoo emerge --usepkgonly lvm2'
end

