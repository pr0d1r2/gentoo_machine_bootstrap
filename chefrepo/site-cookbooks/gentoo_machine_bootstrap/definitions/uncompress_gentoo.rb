define :uncompress_gentoo do
  uncompress_gentoo_root = params[:name] || raise('give destination directory as first parameter')

  with_marker_file :uncompress_gentoo do
    execute "xz -cd #{uncompress_gentoo_root}/stage-latest.tar.xz | tar xf - -C #{uncompress_gentoo_root}"
  end
end
