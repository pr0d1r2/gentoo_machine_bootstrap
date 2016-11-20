with_marker_file :make_root_fs do
  directory '/mnt/gentoo'

  execute "mount #{node[:system_disk][:target_partition]} /mnt/gentoo" do
    not_if { filesystem_mount?("#{node[:system_disk][:target_partition]} /mnt/gentoo") }
  end
end
