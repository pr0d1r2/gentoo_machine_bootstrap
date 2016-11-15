download_gentoo '/mnt/gentoo' do
  arch node[:arch]
end

download_portage '/mnt/gentoo'
