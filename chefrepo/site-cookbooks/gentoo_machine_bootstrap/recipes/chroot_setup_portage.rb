make_conf_use 'MAKEOPTS="-j' + `nproc`.strip + '"'
make_conf_use 'FEATURES="buildpkg"'
