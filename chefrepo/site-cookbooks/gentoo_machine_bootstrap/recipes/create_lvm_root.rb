include_recipe 'lvm2'

with_marker_file :create_lvm_root do
  lvcreate_attributes = %W[
    -L +100%FREE
    #{node[:system_disk][:lvm][:vg_name]}
    -n #{node[:system_disk][:lvm][:root_name]}
  ].join(' ')

  execute "lvcreate #{lvcreate_attributes}"
end
