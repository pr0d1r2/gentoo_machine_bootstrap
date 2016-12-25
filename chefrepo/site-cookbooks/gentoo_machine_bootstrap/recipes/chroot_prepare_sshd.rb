with_marker_file :chroot_prepare_sshd do
  execute 'chroot /mnt/gentoo/ rc-update add sshd default' do
    not_if { node[:gentoo][:release] == 'systemd' }
  end

  # TODO: systemd support

  directory '/mnt/gentoo/root/.ssh' do
    owner 'root'
    mode '0700'
  end

  cookbook_file '/mnt/gentoo/root/.ssh/authorized_keys' do
    source "id_rsa_#{node[:authorized_key_name]}.pub"
    owner 'root'
    mode '0600'
  end
end
