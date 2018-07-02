directory '/mnt/gentoo/etc/portage/package.keywords' do
  recursive true
end

directory '/mnt/gentoo/etc/portage/package.unmask' do
  recursive true
end

execute 'echo "dev-libs/openssl ~amd64" > /mnt/gentoo/etc/portage/package.keywords/openssl'
execute 'echo "=dev-libs/openssl-1.0.2o-r6" > /mnt/gentoo/etc/portage/package.unmask/openssl'

execute 'USE=-bindist chroot /mnt/gentoo emerge --usepkg openssl openssh'

execute 'chroot /mnt/gentoo emerge --usepkg layman' do
  not_if { system('chroot /mnt/gentoo which layman 1>/dev/null 2>/dev/null') }
end

ssnb_path = '/mnt/gentoo/var/lib/layman/ssnb'

execute 'chroot /mnt/gentoo layman -s ALL' do
  not_if { File.directory?(ssnb_path) }
end

execute 'echo y | chroot /mnt/gentoo layman -a ssnb' do
  not_if { File.directory?(ssnb_path) }
end

execute 'echo "app-admin/chefdk-omnibus ~amd64" > /mnt/gentoo/etc/portage/package.keywords/chefdk-omnibus'

execute 'chroot /mnt/gentoo emerge --autounmask-write --usepkg chefdk-omnibus' do
  not_if { system('chroot /mnt/gentoo which chef-solo 1>/dev/null 2>/dev/null') }
end
