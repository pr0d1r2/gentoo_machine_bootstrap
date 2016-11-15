include_recipe 'gentoo_machine_bootstrap::create_partition'
include_recipe 'gentoo_machine_bootstrap::encrypt_partition'

include_recipe 'gentoo_machine_bootstrap::create_lvm'
include_recipe 'gentoo_machine_bootstrap::create_lvm_vg'
include_recipe 'gentoo_machine_bootstrap::create_lvm_root'

include_recipe 'gentoo_machine_bootstrap::make_root_fs'
include_recipe 'gentoo_machine_bootstrap::mount_root_fs'

include_recipe 'gentoo_machine_bootstrap::download_gentoo'
include_recipe 'gentoo_machine_bootstrap::uncompress_gentoo'

include_recipe 'gentoo_machine_bootstrap::mount_pseudo_filesystems'

include_recipe 'gentoo_machine_bootstrap::setup_grub'

include_recipe 'gentoo_machine_bootstrap::remind_to_set_root_fs_luks_key'
