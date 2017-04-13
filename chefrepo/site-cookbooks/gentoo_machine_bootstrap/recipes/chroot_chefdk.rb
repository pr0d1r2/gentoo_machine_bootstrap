execute 'chroot /mnt/gentoo emerge --usepkg layman' do
  not_if { system('chroot /mnt/gentoo which layman &>/dev/null') }
end

ssnb_path = '/mnt/gentoo/var/lib/layman/ssnb'

execute 'chroot /mnt/gentoo layman -s ALL' do
  not_if { File.directory?(ssnb_path) }
end

execute 'echo y | chroot /mnt/gentoo layman -a ssnb' do
  not_if { File.directory?(ssnb_path) }
end


directory '/mnt/gentoo/etc/portage/package.keywords' do
  recursive true
end

execute 'echo "app-admin/chefdk-omnibus ~amd64" > /mnt/gentoo/etc/portage/package.keywords/chefdk-omnibus'

execute 'chroot /mnt/gentoo emerge --usepkg chefdk-omnibus' do
  not_if { system('chroot /mnt/gentoo which chef-solo &>/dev/null') }
end
