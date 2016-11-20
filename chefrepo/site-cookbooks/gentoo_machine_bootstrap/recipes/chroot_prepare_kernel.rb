with_marker_file :chroot_prepare_kernel_gentoo_sources do
  execute 'USE="symlink" chroot /mnt/gentoo emerge gentoo-sources'
end

with_marker_file :chroot_prepare_kernel_genkernel do
  directory '/mnt/gentoo/usr/portage/packages'
  directory '/mnt/gentoo/usr/portage/packages/app-arch'

  remote_file '/mnt/gentoo/usr/portage/packages/app-arch/cpio-2.12-r1.tbz2' do
    source "#{node[:gentoo][:pkg_source]}/cpio-2.12-r1.tbz2"
    checksum 'afae07977efe1c5ea283b3bed591123e5e22875e255cff16aaa8ff77b7f4e3b9'
  end

  directory '/mnt/gentoo/usr/portage/packages/sys-fs'

  remote_file '/mnt/gentoo/usr/portage/packages/sys-fs/cryptsetup-1.7.2.tbz2' do
    source "#{node[:gentoo][:pkg_source]}/cryptsetup-1.7.2.tbz2"
    checksum '4a309e19c90c5e41667387f275f6cade5d7a148f8b21d6228e4de1213f4dd3d2'
  end

  directory '/mnt/gentoo/usr/portage/packages/sys-kernel'

  remote_file '/mnt/gentoo/usr/portage/packages/sys-kernel/genkernel-3.4.52.4-r2.tbz2' do
    source "#{node[:gentoo][:pkg_source]}/genkernel-3.4.52.4-r2.tbz2"
    checksum '99d74eece725439c548e55ce62416bdc4d20e64267dd9d98931a11ff83038642'
  end

  execute 'USE="cryptsetup" chroot /mnt/gentoo emerge --usepkgonly genkernel'

  execute "echo 'OLDCONFIG=\"no\"' >> /mnt/gentoo/etc/genkernel.conf"
  execute "echo 'CLEAN=\"no\"' >> /mnt/gentoo/etc/genkernel.conf"
  execute "echo 'MRPROPER=\"no\"' >> /mnt/gentoo/etc/genkernel.conf"
  execute "echo 'LUKS=\"yes\"' >> /mnt/gentoo/etc/genkernel.conf"
  execute "echo 'DISKLABEL=\"yes\"' >> /mnt/gentoo/etc/genkernel.conf"
  execute "echo 'BOOTLOADER=\"grub2\"' >> /mnt/gentoo/etc/genkernel.conf"
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

  [node[:hardware]].flatten.each do |hardware|
    include_recipe "hardware::#{hardware}"
  end
end

with_marker_file :chroot_prepare_kernel_build do
  execute 'chroot /mnt/gentoo genkernel all'
end
