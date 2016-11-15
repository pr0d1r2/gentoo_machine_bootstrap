with_marker_file :mount_pseudo_filesystems_proc do
  execute 'mount proc -t proc /mnt/gentoo/proc'
end

execute 'ln -sf ../proc/self/mounts /mnt/gentoo/etc/mtab'

with_marker_file :mount_pseudo_filesystems_tmp do
  execute 'mount tmpfs -t tmpfs /mnt/gentoo/tmp'
end

with_marker_file :mount_pseudo_filesystems_dev do
  execute 'mount --rbind /dev /mnt/gentoo/dev'
end

with_marker_file :mount_pseudo_filesystems_sys do
  execute 'mount --rbind /sys /mnt/gentoo/sys'
end

with_marker_file :mount_pseudo_filesystems_run do
  execute 'mount --rbind /run /mnt/gentoo/run'
end
