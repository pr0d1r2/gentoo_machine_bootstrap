#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`
UNAME=`uname`

function echorun() {
  echo "$@"
  $@ || return $?
}

function ensure_command() {
  local ensure_command_COMMAND=$1
  case $2 in
    "")
      local ensure_command_PACKAGE="$ensure_command_COMMAND"
      ;;
    *)
      local ensure_command_PACKAGE="$2 $3 $4 $5 $6 $7 $8 $9"
      ;;
  esac
  which $ensure_command_COMMAND &>/dev/null
  if [ $? -gt 0 ]; then
    case $UNAME in
      Darwin)
        echorun brew install $ensure_command_PACKAGE || return $?
        ;;
      *)
        echo "Please install package for command $ensure_command_COMMAND"
        return 8472
        ;;
    esac
  fi
}

function cpu_num() {
  case $UNAME in
    Darwin)
      /usr/sbin/sysctl -n hw.ncpu
      ;;
    Linux)
      nproc
      ;;
    *)
      return 1
      ;;
  esac
}

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

echorun packer build $D_R/packer-virtualbox.json || return $?
