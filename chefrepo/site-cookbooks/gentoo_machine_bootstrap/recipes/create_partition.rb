# include_recipe 'parted'

with_marker_file :create_partition do
  execute "parted -s #{node[:system_disk][:device_by_id]} mktable msdos" do
    not_if { partition_table_exists?(node[:system_disk][:device_by_id], 'msdos') }
  end

  execute "parted -s #{node[:system_disk][:device_by_id]} mkpart primary 0% 100% -a cylinder" do
    not_if { partition_exists?(node[:system_disk][:device_by_id], 1) }
  end
end
