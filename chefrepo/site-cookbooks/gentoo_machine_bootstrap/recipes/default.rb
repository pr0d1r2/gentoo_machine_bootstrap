execute 'vbetool dpms off' unless node[:testing]

if node[:testing_on_travis]
  directory '/mnt/gentoo'
else
  include_recipe 'gentoo_machine_bootstrap::create_partition'
  include_recipe 'gentoo_machine_bootstrap::encrypt_partition'

  if node[:system_disk][:lvm][:enabled]
    include_recipe 'gentoo_machine_bootstrap::create_lvm'
    include_recipe 'gentoo_machine_bootstrap::create_lvm_vg'
    include_recipe 'gentoo_machine_bootstrap::create_lvm_root'
  end

  include_recipe 'gentoo_machine_bootstrap::make_root_fs'
  include_recipe 'gentoo_machine_bootstrap::mount_root_fs'
end

include_recipe 'gentoo_machine_bootstrap::download_gentoo'
include_recipe 'gentoo_machine_bootstrap::uncompress_gentoo'

include_recipe 'gentoo_machine_bootstrap::mount_pseudo_filesystems'

include_recipe 'gentoo_machine_bootstrap::set_testing_root_password' if node[:testing]

include_recipe 'gentoo_machine_bootstrap::chroot_prepare_resolv_conf'
include_recipe 'gentoo_machine_bootstrap::chroot_set_locale'
include_recipe 'gentoo_machine_bootstrap::chroot_sync_portage'
include_recipe 'gentoo_machine_bootstrap::chroot_setup_portage'
include_recipe 'gentoo_machine_bootstrap::chroot_prepare_binary_packages' unless node[:gentoo][:binary_packages_cache] == ''
include_recipe 'gentoo_machine_bootstrap::chroot_chefdk' if node[:gentoo][:chefdk]
include_recipe 'gentoo_machine_bootstrap::chroot_converge'

include_recipe 'gentoo_machine_bootstrap::chroot_install_grub'
include_recipe 'gentoo_machine_bootstrap::chroot_systemd' if node[:gentoo][:release] == 'systemd'

include_recipe 'gentoo_machine_bootstrap::chroot_prepare_fstab'
include_recipe 'gentoo_machine_bootstrap::setup_grub' unless node[:testing_on_travis]
include_recipe 'gentoo_machine_bootstrap::chroot_prepare_kernel' if node[:gentoo][:genkernel]

include_recipe 'gentoo_machine_bootstrap::chroot_prepare_network'
include_recipe 'gentoo_machine_bootstrap::chroot_prepare_sshd'


include_recipe 'gentoo_machine_bootstrap::remind_to_set_root_fs_luks_key' unless node[:testing]
include_recipe 'gentoo_machine_bootstrap::remind_to_set_root_password' unless node[:testing]

execute 'vbetool dpms on' unless node[:testing]
