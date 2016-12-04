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
  GRUB_CMDLINE_LINUX="crypt_root=/dev/sda2
                      rootfstype=ext4
                      real_root=#{node[:system_disk][:target_partition]}
                      initrd=/dev/ram0
                      #{'nomodeset' if node[:system_disk][:usb]}
                      #{'init=/usr/lib/systemd/systemd' if node[:gentoo][:release] == 'systemd'}"
].join(' ').strip
execute "echo '#{contents}' >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

execute "chroot /mnt/gentoo grub-install #{node[:system_disk][:device_by_id]}"

execute 'chroot /mnt/gentoo grub-mkconfig -o /boot/grub/grub.cfg'
