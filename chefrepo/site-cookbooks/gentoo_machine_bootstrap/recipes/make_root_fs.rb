include_recipe 'lvm2'

with_marker_file :make_root_fs do
  target_partition = "/dev/mapper/#{node[:system_disk][:lvm][:vg_name]}-#{node[:system_disk][:lvm][:root_name]}"

  execute "mkfs.ext4 #{target_partition}" do
    not_if { filesystem_can_be_mount?(target_partition) }
  end
end
