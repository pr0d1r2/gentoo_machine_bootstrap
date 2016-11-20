#!/bin/sh

D_R=`cd \`dirname $1\` ; pwd -P`
HOSTNAME=$1

case $HOSTNAME in
  "")
    echo "You must give hostname as first param!!!"
    return 8472
    ;;
esac

function echorun() {
  echo "$@"
  $@ || return $?
}

function cpu_num() {
  case $UNAME in
    Linux)
      cat /proc/cpuinfo | grep "^processor" | wc -l
      ;;
    *)
      /usr/sbin/sysctl -n hw.ncpu
      ;;
  esac
}

function bundler_threads() {
  expr `cpu_num` \* 4
}

cd $D_R
bundle install -j `bundler_threads` || return $?

if [ ! -f $D_R/nodes/$HOSTNAME.setup-done ]; then
  if [ ! -f $HOME/.ssh/id_rsa_$HOSTNAME ]; then
    echorun ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$HOSTNAME -C $HOSTNAME@`hostname` -o -a 500 || return $?
  fi
  ssh ubuntu@$HOSTNAME 'mkdir ~/.ssh/'
  echorun scp $HOME/.ssh/id_rsa_$HOSTNAME.pub ubuntu@$HOSTNAME:~/.ssh/authorized_keys || return $?

  cat $HOME/.ssh/config | grep -q "^Host $HOSTNAME$"
  if [ $? -gt 0 ]; then
    echo "Host $HOSTNAME" >> $HOME/.ssh/config
    echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> $HOME/.ssh/config
  fi

  ssh-add ~/.ssh/id_rsa_$HOSTNAME

  cp ~/.ssh/id_rsa_$HOSTNAME.pub $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/id_rsa_$HOSTNAME.pub

  echorun knife solo prepare ubuntu@$HOSTNAME || return $?

  touch $D_R/nodes/$HOSTNAME.setup-done
fi

echorun knife solo cook ubuntu@$HOSTNAME || return $?
