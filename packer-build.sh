#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`

source $D_R/functions.sh || return $?

function sha256hash() {
  shasum -a 256 $1 | cut -f 1 -d ' '
}

function confirm_checksum() {
  local confirm_checksum_SUM=`sha256hash $1`
  case $confirm_checksum_SUM in
    $2)
      ;;
    *)
      echo "Bad checksum for $1 (REMOVING) [expected: $2, was $confirm_checksum_SUM]"
      rm -f $1
      return 101
      ;;
  esac
}

function download_with_checksum() {
  local download_with_checksum_BASENAME=`basename $1`
  cd $D_R/packer_cache || return $?
  if [ ! -f $download_with_checksum_BASENAME ]; then
    axel $1 || return $?
  fi
  confirm_checksum `pwd -P`/$download_with_checksum_BASENAME $2 || return $?
  cd - &>/dev/null
}

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

echorun ensure_command axel || return $?
echorun ensure_command packer || return $?
echorun ensure_command VBoxManage Caskroom/cask/virtualbox Caskroom/cask/virtualbox-extension-pack || return $?

CPU_NUM=`cpu_num` || return $?
if [ $? -gt 0 ]; then
  echo 'Unable to determine number of logical cores'
  return 1001
fi
MEMORY=`expr $CPU_NUM \* 512` # MB

cat $D_R/packer-virtualbox.json-template | \
  sed -e "s/CPU_NUM/$CPU_NUM/g" | \
  sed -e "s/MEMORY/$MEMORY/g" > $D_R/packer-virtualbox.json

setup_local_ssh_key default || return $?

cache_gentoo_and_portage || exit $?

echorun packer build $D_R/packer-virtualbox.json || return $?
