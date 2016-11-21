with_marker_file :chroot_set_locale do
  execute 'chroot /mnt/gentoo eselect locale set en_US.UTF8'

  execute 'echo "en_US.UTF-8 UTF-8" > /mnt/gentoo/etc/locale.gen'

  execute 'chroot /mnt/gentoo locale-gen'

  execute 'chroot /mnt/gentoo localectl set-locale LANG=en_US.UTF8'
end
