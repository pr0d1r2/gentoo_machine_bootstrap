execute "echo 'MAKEOPTS=\"-j$(nproc)\"' >> /mnt/gentoo/etc/portage/make.conf" do
  not_if { File.open('/mnt/gentoo/etc/portage/make.conf').include?('MAKEOPTS="-j$(nproc)"') }
end
