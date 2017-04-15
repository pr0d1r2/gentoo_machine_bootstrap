define :download_portage do
  portage_version = '20170414'
  portage_checksum = '3b21a7f8837daaa5cf277daa6de0c6330d139dfebc5a472c2a142347aa17e4af'

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
