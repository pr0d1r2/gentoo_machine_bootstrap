execute 'vbetool dpms off'

include_recipe 'gentoo_machine_bootstrap::create_partition'
include_recipe 'gentoo_machine_bootstrap::encrypt_partition'

if node[:system_disk][:lvm][:enabled]
  include_recipe 'gentoo_machine_bootstrap::create_lvm'
  include_recipe 'gentoo_machine_bootstrap::create_lvm_vg'
  include_recipe 'gentoo_machine_bootstrap::create_lvm_root'
end

include_recipe 'gentoo_machine_bootstrap::make_root_fs'
include_recipe 'gentoo_machine_bootstrap::mount_root_fs'

include_recipe 'gentoo_machine_bootstrap::download_gentoo'
include_recipe 'gentoo_machine_bootstrap::uncompress_gentoo'

include_recipe 'gentoo_machine_bootstrap::mount_pseudo_filesystems'

include_recipe 'gentoo_machine_bootstrap::chroot_prepare_resolv_conf'
include_recipe 'gentoo_machine_bootstrap::chroot_set_locale'
include_recipe 'gentoo_machine_bootstrap::chroot_sync_portage'
include_recipe 'gentoo_machine_bootstrap::chroot_install_lvm2'
include_recipe 'gentoo_machine_bootstrap::chroot_install_grub'

include_recipe 'gentoo_machine_bootstrap::setup_grub'
include_recipe 'gentoo_machine_bootstrap::chroot_prepare_kernel' if node[:gentoo][:genkernel]
include_recipe 'gentoo_machine_bootstrap::chroot_prepare_fstab'

include_recipe 'gentoo_machine_bootstrap::remind_to_set_root_fs_luks_key'
include_recipe 'gentoo_machine_bootstrap::remind_to_set_root_password'

execute 'vbetool dpms on'
