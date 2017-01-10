define :download_portage do
  portage_version = '20170109'
  portage_checksum = '12b9ab97ed03bb2b005f4370d79b8710dc87c405f1322941109b8af6f048f743'

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
