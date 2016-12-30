#!/bin/bash

D_R=`cd \`dirname $1\` ; pwd -P`
HOSTNAME=$1

case $HOSTNAME in
  "")
    echo "You must give hostname as first param!!!"
    return 8472
    ;;
esac

source $D_R/functions.sh || return $?

cd $D_R
bundle install -j `bundler_threads` || return $?

if [ ! -f $D_R/nodes/$HOSTNAME.setup-done ]; then
  setup_local_ssh_key $HOSTNAME || return $?

  ssh ubuntu@$HOSTNAME 'mkdir ~/.ssh/'
  echorun scp $HOME/.ssh/id_rsa_$HOSTNAME.pub ubuntu@$HOSTNAME:~/.ssh/authorized_keys || return $?

  cat $HOME/.ssh/config | grep -q "^Host $HOSTNAME$"
  if [ $? -gt 0 ]; then
    echo "Host $HOSTNAME" >> $HOME/.ssh/config
    echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> $HOME/.ssh/config
  fi

  echorun knife solo prepare ubuntu@$HOSTNAME || return $?

  touch $D_R/nodes/$HOSTNAME.setup-done
fi

echorun knife solo cook ubuntu@$HOSTNAME || return $?
