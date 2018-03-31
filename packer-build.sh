#!/bin/bash

D_R=$(cd "$(dirname "$0")" || exit 1 ; pwd -P)
export PATH="$D_R:$PATH"

# shellcheck disable=SC1090
source "$D_R/functions.sh" || return $?

DOWNLOAD_GENTOO_FILE="$D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_gentoo.rb"
DOWNLOAD_PORTAGE_FILE="$D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_portage.rb"

function cache_gentoo_and_portage() {
  GENTOO_VERSION=$(grep "gentoo_version = '" "$DOWNLOAD_GENTOO_FILE" | head -n 1  | cut -f 2 -d "'")
  GENTOO_CHECKSUM=$(grep "gentoo_checksum = '" "$DOWNLOAD_GENTOO_FILE" | head -n 1  | cut -f 2 -d "'")
  PORTAGE_VERSION=$(grep "portage_version = '" "$DOWNLOAD_PORTAGE_FILE" | cut -f 2 -d "'")
  PORTAGE_CHECKSUM=$(grep "portage_checksum = '" "$DOWNLOAD_PORTAGE_FILE" | cut -f 2 -d "'")

  download_with_checksum \
    "http://mirror.switch.ch/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-$GENTOO_VERSION.tar.xz" \
    "$GENTOO_CHECKSUM" || return $?

  download_with_checksum \
    "http://mirror.switch.ch/ftp/mirror/gentoo/snapshots/portage-$PORTAGE_VERSION.tar.xz" \
    "$PORTAGE_CHECKSUM" || return $?
}

echorun git submodule update --init || exit $?
echorun git submodule update --recursive --remote --force || exit $?

echorun ensure_command axel || exit $?
echorun ensure_command packer || exit $?
echorun ensure_command VBoxManage Caskroom/cask/virtualbox Caskroom/cask/virtualbox-extension-pack || exit $?

CPU_NUM=$(nproc) || exit $?
MEMORY=$((CPU_NUM * 512)) # MB

# shellcheck disable=SC2002
cat "$D_R/packer-virtualbox.json-template" | \
  sed -e "s/CPU_NUM/$CPU_NUM/g" | \
  sed -e "s/MEMORY/$MEMORY/g" > "$D_R/packer-virtualbox.json"

setup_local_ssh_key default || exit $?

cache_gentoo_and_portage || exit $?

bundle install || return $?
cd chefrepo || return $?
berks install || return $?
cd - || return $?

if [ ! -d "$D_R/packer_cache/packages" ]; then
  if [ -e "$D_R/packer_cache/packages" ]; then
    rm -f "$D_R/packer_cache/packages" || exit $?
  fi
fi

echorun packer build "$D_R/packer-virtualbox.json" || exit $?

BINARY_PACKAGES_RECIPE="$D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/recipes/chroot_prepare_binary_packages.rb"
for PACKAGE_FILE in $(find "$D_R/packer_cache/packages" -type f | grep -v sys-kernel/gentoo-sources)
do
  # shellcheck disable=SC2001
  PACKAGE_FILE=$(echo "$PACKAGE_FILE" | sed -e "s|$D_R/packer_cache/packages/||")
  PACKAGE_DEFINITION="gentoo_binary_package '$PACKAGE_FILE'"
  if ! (grep -q "$PACKAGE_DEFINITION" "BINARY_PACKAGES_RECIPE"); then
    echo "$PACKAGE_DEFINITION" >> "$BINARY_PACKAGES_RECIPE" || exit $?
  fi
done
sort < "$BINARY_PACKAGES_RECIPE" > "$BINARY_PACKAGES_RECIPE.tmp" || exit $?
mv "$BINARY_PACKAGES_RECIPE.tmp" "$BINARY_PACKAGES_RECIPE" || exit $?

if (which vagrant &>/dev/null); then
  if (vagrant box list | grep -q "^gentoo-amd64-stage3 "); then
    echorun vagrant box remove gentoo-amd64-stage3 || exit $?
    echorun vagrant box add "$D_R/gentoo-amd64-stage3-virtualbox.box" --name gentoo-amd64-stage3 || exit $?
  fi
fi
