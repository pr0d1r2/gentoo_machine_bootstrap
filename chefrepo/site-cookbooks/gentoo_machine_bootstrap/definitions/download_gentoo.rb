define :download_gentoo do

  download_gentoo_root = params[:name] || raise('give destination directory as first parameter')
  download_gentoo_arch = params[:arch] || raise('arch is required')
  download_gentoo_release = params[:release] || raise('release is required')
  download_gentoo_hardened = params[:hardened]
  download_gentoo_stage = params[:stage]
  raise('hardened is required') if download_gentoo_hardened.nil?

  gentoo_subdir = ''

  case download_gentoo_arch
  when 'x86_64'
    case download_gentoo_release
    when 'systemd'
      case download_gentoo_stage
      when 3
        gentoo_version = '20161113'
        gentoo_checksum = '8b0db2a7ebd80d2fa3ad4413c7a8815c9391dd46301bf79fad3f66d00a20e7ce'
        gentoo_basename = "stage3-amd64-systemd-#{gentoo_version}.tar.bz2"
        if node[:gentoo][:mirror][:subdirectories]
          gentoo_subdir = '/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage3-amd64-systemd'
        end
      else
        raise "Unknown stage: #{download_gentoo_stage} (for release #{download_gentoo_release})"
      end
    when 'cloud'
      case download_gentoo_stage
      when 4
        gentoo_version = '20161117'
        if download_gentoo_hardened
          gentoo_checksum = '560f468051ecec0452d58d0ae0c8aa5c18991b80510e7cad5fed27a3c9f4e015'
          gentoo_basename = "stage4-amd64-hardened+cloud-#{gentoo_version}.tar.bz2"
          if node[:gentoo][:mirror][:subdirectories]
            gentoo_subdir = '/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage4-amd64-hardened+cloud'
          end
        else
          gentoo_checksum = 'a7be39029c8da7b7e82d3745affd0b3e6c63c8bf9b4a2f465045571d79b75244'
          gentoo_basename = "stage4-amd64-cloud-#{gentoo_version}.tar.bz2"
          if node[:gentoo][:mirror][:subdirectories]
            gentoo_subdir = '/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage4-amd64-cloud'
          end
        end
      else
        raise "Unknown stage: #{download_gentoo_stage} (for release #{download_gentoo_release})"
      end
    else
      raise "Unknown release: #{download_gentoo_release}"
    end
  else
    raise "Unknown architecture: #{download_gentoo_arch}"
  end

  gentoo_url = "#{node[:gentoo][:mirror][:path]}/#{gentoo_subdir}/#{gentoo_basename}"

  downloaded_file = "#{download_gentoo_root}/#{gentoo_basename}"

  remote_file downloaded_file do
    source gentoo_url
    checksum gentoo_checksum
  end

  link "#{download_gentoo_root}/stage-latest.tar.bz2" do
    to downloaded_file
  end
end
