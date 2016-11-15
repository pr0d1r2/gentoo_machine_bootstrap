define :download_portage do
  portage_version = '20161114'
  portage_checksum = 'a84d1261c884409fa9b3b726323c435d'

  download_portage_root = params[:name] || raise('give destination directory as first parameter')

  with_marker_file :download_portage do
    downloaded_file = "#{download_portage_root}/portage-#{portage_version}.tar.xz"

    remote_file downloaded_file do
      source "http://mirror.switch.ch/ftp/mirror/gentoo/snapshots/portage-#{portage_version}.tar.xz"
      checksum portage_checksum
    end

    link downloaded_file do
      to "#{download_portage_root}/portage-latest.tar.xz"
    end
  end
end
