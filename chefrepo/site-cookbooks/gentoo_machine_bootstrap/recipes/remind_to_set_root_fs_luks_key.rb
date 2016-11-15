with_marker_file :remind_to_set_root_fs_luks_key do
  fail %W[
    Please add your own key to rootfs LUKS keychain before restart!!!
    You can do this by executing:
    cryptsetup luksAddKey #{target_disk_from_id(node[:system_disk][:device_by_id])}1
    &&
    touch /etc/chef/.gentoo_machine_bootstrap-remind_to_set_root_fs_luks_key.done
  ].join(' ')
end
