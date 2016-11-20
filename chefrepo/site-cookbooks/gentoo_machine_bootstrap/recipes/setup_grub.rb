file = '/mnt/gentoo/etc/default/grub'

contents = 'GRUB_ENABLE_CRYPTODISK=y'
execute "echo #{contents} >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

contents = 'GRUB_DEVICE="/dev/ram0"'
execute "echo #{contents} >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

contents = %W[
  GRUB_CMDLINE_LINUX="crypt_root=/dev/sda1
                      rootfstype=ext4
                      real_root=#{node[:system_disk][:target_partition]}
                      initrd=/dev/ram0"
].join(' ')
execute "echo '#{contents}' >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

execute 'chroot /mnt/gentoo grub-mkconfig -o /boot/grub/grub.cfg'

execute "chroot /mnt/gentoo grub-install #{node[:system_disk][:device_by_id]}"
