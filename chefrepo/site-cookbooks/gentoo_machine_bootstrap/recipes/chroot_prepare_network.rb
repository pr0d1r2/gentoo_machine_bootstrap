with_marker_file :chroot_prepare_network do
  [node[:network_devices]].flatten.compact.each do |network_device|
    execute "chroot /mnt/gentoo ln -sf /etc/init.d/net.lo /etc/init.d/net.#{network_device}" do
      not_if { node[:gentoo][:release] == 'systemd' || File.exist?("/etc/init.d/net.#{network_device}") }
    end

    execute "chroot /mnt/gentoo/ rc-update add net.#{network_device} default" do
      not_if { node[:gentoo][:release] == 'systemd' }
    end
  end
end

execute "echo 'hostname=\"#{node[:hostname]}\"' > /mnt/gentoo/etc/conf.d/hostname" do
  not_if { node[:gentoo][:release] == 'systemd' }
end
