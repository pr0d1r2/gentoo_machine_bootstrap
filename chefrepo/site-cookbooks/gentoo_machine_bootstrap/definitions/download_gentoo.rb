define :download_gentoo do

  download_gentoo_root = params[:name] || raise('give destination directory as first parameter')
  download_gentoo_arch = params[:arch] || raise('arch is required')
  download_gentoo_release = params[:release] || raise('release is required')
  download_gentoo_hardened = params[:hardened]
  download_gentoo_stage = params[:stage]
  gentoo_compression_suffix = 'bz2'
  raise('hardened is required') if download_gentoo_hardened.nil?

  gentoo_subdir = ''

  case download_gentoo_arch
  when 'x86_64'
    case download_gentoo_release
    when 'vanilla'
      case download_gentoo_stage
      when 3
        gentoo_version = '20190716T103222Z'
        gentoo_checksum = '8c8595b425bc12d44f8ce494deb713c9159b9b80ad13ed8cdb6543b28fc477bb'
        gentoo_compression_suffix = 'xz'
        gentoo_basename = "stage3-amd64-#{gentoo_version}.tar.#{gentoo_compression_suffix}"
        if node[:gentoo][:mirror][:subdirectories]
          gentoo_subdir = 'download/gentoo-mirror/releases/amd64/autobuilds/current-stage3-amd64'
        end
      else
        raise "Unknown stage: #{download_gentoo_stage} (for release #{download_gentoo_release})"
      end
    when 'systemd'
      case download_gentoo_stage
      when 3
        gentoo_version = '20190713'
        gentoo_checksum = '8dd7d510309633960571d07556e35d6236bf91b03d37b670afdd093cdb05f5c5'
        gentoo_basename = "stage3-amd64-systemd-#{gentoo_version}.tar.#{gentoo_compression_suffix}"
        if node[:gentoo][:mirror][:subdirectories]
          gentoo_subdir = 'download/gentoo-mirror/releases/amd64/autobuilds/current-stage3-amd64-systemd'
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
          gentoo_basename = "stage4-amd64-hardened+cloud-#{gentoo_version}.tar.#{gentoo_compression_suffix}"
          if node[:gentoo][:mirror][:subdirectories]
            gentoo_subdir = 'download/gentoo-mirror/releases/amd64/autobuilds/current-stage4-amd64-hardened+cloud'
          end
        else
          gentoo_checksum = 'a7be39029c8da7b7e82d3745affd0b3e6c63c8bf9b4a2f465045571d79b75244'
          gentoo_basename = "stage4-amd64-cloud-#{gentoo_version}.tar.#{gentoo_compression_suffix}"
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

  link "#{download_gentoo_root}/stage-latest.tar.#{gentoo_compression_suffix}" do
    to downloaded_file
  end
end
