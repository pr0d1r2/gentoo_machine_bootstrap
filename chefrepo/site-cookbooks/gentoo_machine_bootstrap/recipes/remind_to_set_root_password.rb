with_marker_file :remind_to_set_root_password do
  message = %W[
    Please change root password before restart!!!
    You can do this by executing:
    chroot /mnt/gentoo passwd
    &&
    touch /etc/chef/.gentoo_machine_bootstrap-remind_to_set_root_password.done
  ].join(' ')

  execute "echo '#{message}' ; false"
end
