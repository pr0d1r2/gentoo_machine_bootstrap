default[:system_disk] = {
  luks: {
    cipher: 'aes-xts-plain',
    hashing: 'sha512',
    key_size: 512,
    key_offset: 0
  },
  mapper_name: 'lvm',
  lvm: {
    vg_name: 'vg',
    root_name: 'root'
  }
}
