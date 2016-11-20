define :uncompress_gentoo do
  uncompress_gentoo_root = params[:name] || raise('give destination directory as first parameter')

  with_marker_file :uncompress_gentoo do
    execute "tar xfj #{uncompress_gentoo_root}/stage-latest.tar.bz2 -C #{uncompress_gentoo_root}"
  end
end
