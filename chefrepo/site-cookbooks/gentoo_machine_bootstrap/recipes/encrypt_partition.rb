with_marker_file :encrypt_partition do
  execute "dd bs=512 count=4 if=/dev/urandom of=#{node[:system_disk][:luks][:tmp_key_file]} iflag=fullblock" do
    not_if { File.exist?(node[:system_disk][:luks][:tmp_key_file]) }
  end

  cryptsetup_arguments = %W[
    --cipher=#{node[:system_disk][:luks][:cipher]}
    --hash=#{node[:system_disk][:luks][:hashing]}
    --key-size=#{node[:system_disk][:luks][:key_size]}
    --offset=#{node[:system_disk][:luks][:key_offset]}
    --batch-mode
    /dev/#{target_disk_from_id(node[:system_disk][:device_by_id])}1
    --key-file #{node[:system_disk][:luks][:tmp_key_file]}
  ].join(' ')

  execute "cryptsetup luksFormat #{cryptsetup_arguments}" do
    not_if { File.exist?("/dev/mapper/#{node[:system_disk][:mapper_name]}") }
  end

  execute "cryptsetup luksOpen #{cryptsetup_arguments} #{node[:system_disk][:mapper_name]}" do
    not_if { File.exist?("/dev/mapper/#{node[:system_disk][:mapper_name]}") }
  end
end
