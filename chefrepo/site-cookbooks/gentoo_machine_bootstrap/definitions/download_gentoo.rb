define :download_gentoo do

  download_gentoo_root = params[:name] || raise('give destination directory as first parameter')
  download_gentoo_arch = params[:arch] || raise('arch is required')

  case download_gentoo_arch
  when 'x86_64'
    gentoo_version = '20161103'
    gentoo_checksum = '7dc7b3a077a88e71f1afde788543aed11fa4ad6e39546a7a0464b24cdc35ff1f'
    gentoo_basename = "stage4-amd64-hardened+cloud-#{gentoo_version}.tar.bz2"
    gentoo_url = "http://mirror.switch.ch/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage4-amd64-hardened+cloud/#{gentoo_basename}"
  else
    raise "Unknown architecture: #{download_gentoo_arch}"
  end

  downloaded_file = "#{download_gentoo_root}/#{gentoo_basename}"

  remote_file downloaded_file do
    source gentoo_url
    checksum gentoo_checksum
  end

  link "#{download_gentoo_root}/stage4-latest.tar.bz2" do
    to downloaded_file
  end
end
