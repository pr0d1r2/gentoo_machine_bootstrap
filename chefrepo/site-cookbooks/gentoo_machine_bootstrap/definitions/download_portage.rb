define :download_portage do
  portage_version = '20161229'
  portage_checksum = '34442497bad00f8a21e39cb8d0973403d3ca699538d0cc5f59c6e2b47249d43a'

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
