define :download_portage do
  portage_version = '20170114'
  portage_checksum = 'fd32d7ad4cce0043097d135fd4af11901fc8a92936ca54937ebe885fadef56f0'

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
