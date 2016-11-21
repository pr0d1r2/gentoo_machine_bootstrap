default[:system_disk] = {
  usb: false,
  label: 'gpt',
  luks: {
    cipher: 'aes-xts-plain',
    hashing: 'sha512',
    key_size: 512,
    key_offset: 0,
    tmp_key_file: '/.urandom'
  },
  mapper_name: 'lvm',
  lvm: {
    enabled: false,
    vg_name: 'vg',
    root_name: 'root'
  }
}

default[:system_disk][:mapper_name] = 'root' unless node[:system_disk][:lvm][:enabled]

default[:system_disk][:target_partition] = if node[:system_disk][:lvm][:enabled]
  "/dev/mapper/#{node[:system_disk][:lvm][:vg_name]}-#{node[:system_disk][:lvm][:root_name]}"
else
  "/dev/mapper/#{node[:system_disk][:mapper_name]}"
end

default[:gentoo] = {
  release: 'systemd',
  hardened: false,
  stage: 3,
  genkernel: true,
  mirror: {
    path: 'http://mirror.switch.ch',
    subdirectories: true
  },
  pkg_source: 'https://raw.githubusercontent.com/pr0d1r2/gentoo_machine_bootstrap-assets/master'
}
