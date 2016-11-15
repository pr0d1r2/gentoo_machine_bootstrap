file = '/mnt/gentoo/etc/default/grub'

contents = 'GRUB_ENABLE_CRYPTODISK=y'
execute "echo #{contents} >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

target_partition = "/dev/mapper/#{node[:system_disk][:lvm][:vg_name]}-#{node[:system_disk][:lvm][:root_name]}"
contents = %W[
  GRUB_CMDLINE_LINUX="console=tty0
                      console=ttyS0,115200n8
                      cryptdevice=/dev/sda1:#{node[:system_disk][:mapper_name]}
                      root=#{target_partition}"
].join(' ')
execute "echo '#{contents}' >> #{file}" do
  not_if { File.read(file).include?(contents) }
end

execute 'chroot /mnt/gentoo grub-mkconfig -o /boot/grub/grub.cfg'

execute "chroot /mnt/gentoo grub-install #{node[:system_disk][:device_by_id]}"
