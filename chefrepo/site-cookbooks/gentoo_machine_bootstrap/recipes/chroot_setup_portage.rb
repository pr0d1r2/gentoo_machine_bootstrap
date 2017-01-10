make_conf_use 'MAKEOPTS="-j' + `nproc`.strip + '"'
make_conf_use 'FEATURES="buildpkg"'

make_conf_use "PORTAGE_BINHOST=\"#{node[:gentoo][:portage_binhost]}\"" do
  not_if { node[:gentoo][:portage_binhost].blank? }
end
