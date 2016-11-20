template '/mnt/gentoo/etc/fstab' do
  source 'fstab.erb'
  variables({
    root_fs: node[:system_disk][:target_partition]
  })
end
