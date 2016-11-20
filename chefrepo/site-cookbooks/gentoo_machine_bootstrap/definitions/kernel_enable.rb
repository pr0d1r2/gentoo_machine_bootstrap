define :kernel_enable do
  config = '/mnt/gentoo/usr/src/linux/.config'
  flag = "#{params[:name]}=y"

  execute "echo '#{flag}' >> #{config}" do
    not_if { File.open(config).include?(flag) }
  end
end
