execute 'cp /etc/resolv.conf /mnt/gentoo/etc/resolv.conf' do
  not_if { File.exist?('/mnt/gentoo/etc/resolv.conf') }
end
