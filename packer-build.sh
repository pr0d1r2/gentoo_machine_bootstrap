#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`

source $D_R/functions.sh || return $?

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

function setup_local_ssh_key() {
  if [ ! -f $HOME/.ssh/id_rsa_$1 ]; then
    echorun ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$1 -C $1@`hostname` -o -a 500 || return $?
  fi

  if [ ! -d $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default ]; then
    mkdir -p $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default || return $?
  fi
  cp ~/.ssh/id_rsa_$1.pub $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default/id_rsa_$1.pub || return $?
  ssh-add ~/.ssh/id_rsa_$1 || return $?
}

setup_local_ssh_key default || return $?

echorun packer build $D_R/packer-virtualbox.json || return $?
