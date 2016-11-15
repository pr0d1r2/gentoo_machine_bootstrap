# include_recipe 'lvm2'

with_marker_file :create_lvm_vg do
  execute "vgcreate #{node[:system_disk][:lvm][:vg_name]} /dev/mapper/#{node[:system_disk][:mapper_name]}"
end
