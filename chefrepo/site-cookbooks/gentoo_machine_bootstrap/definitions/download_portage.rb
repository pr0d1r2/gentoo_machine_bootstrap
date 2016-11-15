define :download_portage do
  portage_version = '20161114'
  portage_checksum = '587e3a7e07b1a8c562157fe866ecc0e64c9d5e8348c17c9bc99c6d220d6d3dcc'

  download_portage_root = params[:name] || raise('give destination directory as first parameter')

  downloaded_file = "#{download_portage_root}/portage-#{portage_version}.tar.xz"

  remote_file downloaded_file do
    source "http://mirror.switch.ch/ftp/mirror/gentoo/snapshots/portage-#{portage_version}.tar.xz"
    checksum portage_checksum
  end

  link "#{download_portage_root}/portage-latest.tar.xz" do
    to downloaded_file
  end
end
