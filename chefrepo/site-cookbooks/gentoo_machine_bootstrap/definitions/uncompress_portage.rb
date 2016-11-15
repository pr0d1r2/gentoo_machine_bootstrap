define :uncompress_portage do
  uncompress_portage_root = params[:name] || raise('give destination directory as first parameter')

  with_marker_file :uncompress_portage do
    uncompress_command = if system('which pxz')
      'pxz'
    else
      'xz'
    end
    execute "#{uncompress_command} -cd #{uncompress_portage_root}/portage-latest.tar.xz | tar xf - -C #{uncompress_portage_root}/usr"
  end
end
