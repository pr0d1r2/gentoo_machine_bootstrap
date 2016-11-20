with_marker_file :make_root_fs do
  execute "mkfs.ext4 #{node[:system_disk][:target_partition]}" do
    not_if { filesystem_can_be_mount?(node[:system_disk][:target_partition]) }
  end
end
