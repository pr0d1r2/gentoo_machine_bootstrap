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

setup_local_ssh_key default || return $?

echorun packer build $D_R/packer-virtualbox.json || return $?
