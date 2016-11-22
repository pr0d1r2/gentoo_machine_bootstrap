# include_recipe 'lvm'

with_marker_file :create_lvm do
  execute "pvcreate /dev/mapper/#{node[:system_disk][:mapper_name]}"
end
