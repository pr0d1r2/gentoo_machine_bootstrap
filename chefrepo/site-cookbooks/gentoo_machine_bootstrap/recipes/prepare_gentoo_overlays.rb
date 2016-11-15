#
# Cookbook Name:: gentoo_machine_bootstrap
# Recipe:: prepare_gentoo_overlays
#
# Copyright 2012, DoubleDrones
#
# All rights reserved - Do Not Redistribute
#

execute 'update-doubledrones-gentoo-overlay' do
  command 'cd /mnt/gentoo/usr/local/portage && git pull'
  only_if { File.directory?("/mnt/gentoo/usr/local/portage") }
end

execute 'prepare-doubledrones-gentoo-overlay' do
  command 'git clone git://github.com/doubledrones/gentoo_overlay.git /mnt/gentoo/usr/local/portage'
  not_if { File.directory?("/mnt/gentoo/usr/local/portage") }
end


#execute 'update-doubledrones-secret-gentoo-overlay' do
  #command 'cd /mnt/gentoo/usr/local/portage_secret && git pull'
  #only_if { File.directory?("/mnt/gentoo/usr/local/portage_secret") }
#end

lithium_available = system("ping -c 1 192.168.88.2")

execute 'prepare-doubledrones-secret-gentoo-overlay-from-local' do
  command 'git clone git@192.168.88.2:secret_gentoo_overlay.git /mnt/gentoo/usr/local/portage_secret'
  only_if { lithium_available }
  not_if { File.directory?("/mnt/gentoo/usr/local/portage_secret") }
end

execute 'prepare-doubledrones-secret-gentoo-overlay-from-remote' do
  command 'git clone ssh://git@176.9.78.10:223/secret_gentoo_overlay.git /mnt/gentoo/usr/local/portage_secret'
  not_if { File.directory?("/mnt/gentoo/usr/local/portage_secret") || lithium_available }
end
