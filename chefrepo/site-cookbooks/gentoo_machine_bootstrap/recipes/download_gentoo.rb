with_marker_file :download_gentoo do
  download_gentoo '/mnt/gentoo' do
    arch node[:arch]
    release node[:gentoo][:release]
    hardened node[:gentoo][:hardened]
    stage node[:gentoo][:stage]
  end
end

with_marker_file :download_portage do
  download_portage '/mnt/gentoo'
end
