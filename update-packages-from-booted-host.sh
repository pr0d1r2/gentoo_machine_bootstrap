#!/bin/bash

# Update packages from booted host
#
# Useful in case of getting build timeouts on packer build

cd "$(dirname "$0")" || return $?

# shellcheck disable=SC1117
parallel \
  'ssh root@{} find /usr/portage/packages/ -name "openss[lh]-*" -o -name "chefdk-omnibus-*" | sed -e "s|^|root@{}:|g" ' \
  ::: \
  "$@" | \
    parallel \
      -v \
      "scp {} {= s:[^\:]+\:::; s/\/usr\/portage/$PACKER_CACHE_DIR/; =}"

exit $?
