define :gentoo_binary_package do
  package_file = params[:name]
  checksum = params[:checksum]

  downloaded_file = "/mnt/gentoo/usr/portage/packages/#{package_file}"
  source = [node[:gentoo][:binary_packages_cache], package_file].join('/')

  if node[:gentoo][:binary_packages_cache][0..18] == 'https://github.com/'
    source += '?raw=true'
  end

  directory File.dirname(downloaded_file) do
    recursive true
  end

  remote_file downloaded_file do
    source source
    checksum checksum
  end
end
