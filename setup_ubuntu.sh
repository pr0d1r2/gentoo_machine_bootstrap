#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`
HOSTNAME=$1
USERNAME=$2

case $HOSTNAME in
  "")
    echo "You must give hostname as first param!!!"
    exit 8472
    ;;
esac
case $USERNAME in
  "")
    USERNAME="ubuntu"
    ;;
esac
source $D_R/functions.sh || exit $?

cd $D_R
bundle install -j `bundler_threads` || exit $?

if [ ! -f $D_R/nodes/$HOSTNAME.setup-done ]; then
  setup_local_ssh_key $HOSTNAME || exit $?

  ssh $USERNAME@$HOSTNAME 'mkdir ~/.ssh/'
  echorun scp $HOME/.ssh/id_rsa_$HOSTNAME.pub $USERNAME@$HOSTNAME:~/.ssh/authorized_keys || exit $?

  cat $HOME/.ssh/config | grep -q "^Host $HOSTNAME$"
  if [ $? -gt 0 ]; then
    echo "Host $HOSTNAME" >> $HOME/.ssh/config
    echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> $HOME/.ssh/config
  fi

  echorun knife solo prepare $USERNAME@$HOSTNAME || exit $?

  touch $D_R/nodes/$HOSTNAME.setup-done
fi

echorun knife solo cook $USERNAME@$HOSTNAME || exit $?
