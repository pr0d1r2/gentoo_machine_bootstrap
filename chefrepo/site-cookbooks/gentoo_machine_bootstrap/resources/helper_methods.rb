class Chef::Resource::Execute
  def partition_table_exists?(disk, type)
    `parted -s /dev/#{disk} print | grep "Partition Table: #{type}"`.strip != ""
  end

  def partition_exists?(disk, num)
    system("parted -s /dev/#{disk} print #{num}")
  end

  def target_disk_from_id(device_by_id)
    `ls -la #{device_by_id} | cut -f 2 -d '>' | cut -f 3 -d /`
  end

  def filesystem_can_be_mount?(device)
    system("mkdir /tmp/mount-test") unless ::File.directory?('/tmp/mount-test')
    retval = system("mount #{device} /tmp/mount-test")
    system('umount /tmp/mount-test')
    retval
  end

  def filesystem_already_mount?(path)
    system("mount | grep 'on #{path}'")
  end
end

def with_marker_file(marker_name)
  marker_file = "/etc/chef/.gentoo_machine_bootstrap-#{marker_name}.done"
  unless File.exist?(marker_file)
    yield
    file marker_file do
      action :create
    end
  end
end
