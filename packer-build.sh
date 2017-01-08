#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`
export PATH="$D_R:$PATH"

source $D_R/functions.sh || return $?

function cache_gentoo_and_portage() {
  GENTOO_VERSION=`cat $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_gentoo.rb | grep "gentoo_version = '" | head -n 1  | cut -f 2 -d "'"`
  GENTOO_CHECKSUM=`cat $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_gentoo.rb | grep "gentoo_checksum = '" | head -n 1  | cut -f 2 -d "'"`
  PORTAGE_VERSION=`cat $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_portage.rb | grep "portage_version = '" | cut -f 2 -d "'"`
  PORTAGE_CHECKSUM=`cat $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/definitions/download_portage.rb | grep "portage_checksum = '" | cut -f 2 -d "'"`

  download_with_checksum \
    http://mirror.switch.ch/ftp/mirror/gentoo/releases/amd64/autobuilds/current-stage3-amd64/stage3-amd64-$GENTOO_VERSION.tar.bz2 \
    $GENTOO_CHECKSUM || return $?

  download_with_checksum \
    http://mirror.switch.ch/ftp/mirror/gentoo/snapshots/portage-$PORTAGE_VERSION.tar.xz \
    $PORTAGE_CHECKSUM || return $?
}

echorun ensure_command axel || exit $?
echorun ensure_command packer || exit $?
echorun ensure_command VBoxManage Caskroom/cask/virtualbox Caskroom/cask/virtualbox-extension-pack || exit $?

CPU_NUM=`cpu_num` || exit $?
if [ $? -gt 0 ]; then
  echo 'Unable to determine number of logical cores'
  return 1001
fi
MEMORY=`expr $CPU_NUM \* 512` # MB

cat $D_R/packer-virtualbox.json-template | \
  sed -e "s/CPU_NUM/$CPU_NUM/g" | \
  sed -e "s/MEMORY/$MEMORY/g" > $D_R/packer-virtualbox.json

setup_local_ssh_key default || exit $?

cache_gentoo_and_portage || exit $?

bundle install || return $?
cd chefrepo || return $?
berks install || return $?
cd - || return $?

if [ ! -d $D_R/packer_cache/packages ]; then
  if [ -e $D_R/packer_cache/packages ]; then
    rm -f $D_R/packer_cache/packages || exit $?
  fi
fi

echorun packer build $D_R/packer-virtualbox.json || exit $?

echorun vagrant box remove gentoo-amd64-stage3 || exit $?
