define :genkernel_use do
  config = '/mnt/gentoo/etc/genkernel.conf'
  flag = params[:name]

  execute "echo '#{flag}' >> #{config}" do
    not_if { system("grep -q '^#{flag}$' config") }
  end
end
