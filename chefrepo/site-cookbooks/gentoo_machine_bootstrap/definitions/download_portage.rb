define :download_portage do
  portage_version = '20161119'
  portage_checksum = 'e811ef0997e17e35eb208d7ff66cced13586f8363a91ec37f2bf0388ccc1fc55'

  download_portage_root = params[:name] || raise('give destination directory as first parameter')

  downloaded_file = "#{download_portage_root}/portage-#{portage_version}.tar.xz"

  if node[:gentoo][:mirror][:subdirectories]
    download_subdir = '/ftp/mirror/gentoo/snapshots'
  else
    download_subdir = ''
  end

  remote_file downloaded_file do
    source "#{node[:gentoo][:mirror][:path]}/#{download_subdir}/portage-#{portage_version}.tar.xz"
    checksum portage_checksum
  end

  link "#{download_portage_root}/portage-latest.tar.xz" do
    to downloaded_file
  end
end
