git '/mnt/gentoo/root/gentoo_converge' do
  repository 'git@github.com:pr0d1r2/gentoo_converge.git'
end

execute 'cp -rvdp /var/chef/node.json /mnt/gentoo/root/gentoo_coverge/node.json'

execute 'chroot /mnt/gentoo /root/gentoo_coverge/setup-on-gentoo.sh'
