with_marker_file :encrypt_partition do
  cryptsetup_arguments = %W[
    --cipher=#{node[:system_disk][:luks][:cipher]}
    --hash=#{node[:system_disk][:luks][:hashing]}
    --key-size=#{node[:system_disk][:luks][:key_size]}
    --offset=#{node[:system_disk][:luks][:key_offset]}
    --type plain
    /dev/#{target_disk_from_id(node[:system_disk][:device_by_id])}1
    #{node[:system_disk][:mapper_name]}
    --key-file /dev/urandom
  ].join(' ')

  execute "cryptsetup open #{cryptsetup_arguments}" do
    not_if { File.exist?("/dev/mapper/#{node[:system_disk][:mapper_name]}") }
  end
end
