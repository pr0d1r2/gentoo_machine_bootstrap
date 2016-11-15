with_marker_file :make_root_fs do
  target_partition = "/dev/mapper/#{node[:system_disk][:lvm][:vg_name]}-#{node[:system_disk][:lvm][:root_name]}"

  directory '/mnt/gentoo'

  execute "mount #{target_partition} /mnt/gentoo" do
    not_if { filesystem_mount?("#{target_partition} /mnt/gentoo") }
  end
end
