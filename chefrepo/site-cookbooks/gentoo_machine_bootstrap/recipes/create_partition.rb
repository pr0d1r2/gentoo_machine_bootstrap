# include_recipe 'parted'

with_marker_file :create_partition do
  execute "parted -s #{node[:system_disk][:device_by_id]} mklabel #{node[:system_disk][:label]}" do
    not_if { partition_table_exists?(node[:system_disk][:device_by_id], node[:system_disk][:label]) }
  end

  if node[:system_disk][:label] == 'gpt'
    execute "parted -s #{node[:system_disk][:device_by_id]} mkpart primary 0% 100M -a cylinder" do
      not_if { partition_exists?(node[:system_disk][:device_by_id], 1) }
    end

    execute "parted -s #{node[:system_disk][:device_by_id]} mkpart bios_grub 100M 100% -a cylinder" do
      not_if { partition_exists?(node[:system_disk][:device_by_id], 2) }
    end

    execute "parted -s #{node[:system_disk][:device_by_id]} set 1 bios_grub on"

    parts = [1, 2]
  else
    # NOTE: start partition from 100M to leave space for grub embedding
    execute "parted -s #{node[:system_disk][:device_by_id]} mkpart primary 100M 100% -a cylinder" do
      not_if { partition_exists?(node[:system_disk][:device_by_id], 1) }
    end

    parts = [1]
  end

  parts.each do |part|
    device = "/dev/#{target_disk_from_id(node[:system_disk][:device_by_id])}#{part}"
    execute "until [ -e #{device} ]; do echo 'Waiting for #{device} to appear'; sleep 1; done"
  end
end
