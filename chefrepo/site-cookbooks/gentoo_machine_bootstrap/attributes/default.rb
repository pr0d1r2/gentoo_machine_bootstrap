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
  release: 'vanilla',
  hardened: false,
  binary_packages_cache: '',
  portage_binhost: '',
  chefdk: true,
  stage: 3,
  genkernel: true,
  mirror: {
    path: 'https://linux.rz.ruhr-uni-bochum.de',
    subdirectories: true
  },
  pkg_source: 'https://raw.githubusercontent.com/pr0d1r2/gentoo_machine_bootstrap-assets/master'
}

default[:testing] = false
default[:testing_on_travis] = false
default[:testing] = true if node[:testing_on_travis]

default[:gentoo][:genkernel] = true if node[:gentoo][:stage] < 4

if node[:automatic] && node[:automatic][:ipaddress]
  default[:authorized_key_name] = node[:automatic][:ipaddress]
else
  default[:authorized_key_name] = 'default'
end

default[:kernel] = {
  params: []
}

default[:ccache] = {} unless node[:ccache]
default[:ccache][:size] = '10G' unless node[:ccache][:size]
