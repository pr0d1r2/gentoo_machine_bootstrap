git '/mnt/gentoo/root/gentoo_converge' do
  repository 'https://github.com/pr0d1r2/gentoo_converge.git'
  enable_submodules false # not need as we do not need extra private configuration
end

execute 'HOME=/root chroot /mnt/gentoo bash /root/gentoo_converge/setup-on-gentoo.sh'
