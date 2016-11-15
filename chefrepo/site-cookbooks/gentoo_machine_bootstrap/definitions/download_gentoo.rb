define :download_gentoo do

  download_gentoo_root = params[:name] || raise('give destination directory as first parameter')
  download_gentoo_arch = params[:arch] || raise('arch is required')

  with_marker_file :download_gentoo do
    case download_gentoo_arch
    when 'x86_64'
      gentoo_version = '20161103'
      gentoo_checksum = '2089b691998e3913730ce61f8b73e9eb23bf9b3ca2b663ea8b308e28e63ba43b6abadd5b6bdfd9e59c8ba89eb6343de3d7b8420602f76bee95604f3b3eb3519b'
      bentoo_basename = "stage4-amd64-hardened+cloud-#{gentoo_version}.tar.bz2"
      gentoo_url = "http://mirror.switch.ch/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage4-amd64-hardened+cloud/#{bentoo_basename}"
    else
      raise "Unknown architecture: #{download_gentoo_arch}"
    end

    downloaded_file = "#{download_gentoo_root}/#{bentoo_basename}"

    remote_file downloaded_file do
      source download_url
      checksum download_checksum
    end

    link downloaded_file do
      to "#{download_gentoo_root}/stage4-latest.tar.xz"
    end
  end
end
