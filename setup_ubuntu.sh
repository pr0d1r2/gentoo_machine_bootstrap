#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`
HOSTNAME=$1

case $HOSTNAME in
  "")
    echo "You must give hostname as first param!!!"
    exit 8472
    ;;
esac

source $D_R/functions.sh || exit $?

cd $D_R
bundle install -j `bundler_threads` || exit $?

if [ ! -f $D_R/nodes/$HOSTNAME.setup-done ]; then
  setup_local_ssh_key $HOSTNAME || exit $?

  ssh ubuntu@$HOSTNAME 'mkdir ~/.ssh/'
  echorun scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null $HOME/.ssh/id_rsa_$HOSTNAME.pub ubuntu@$HOSTNAME:~/.ssh/authorized_keys || exit $?

  cat $HOME/.ssh/config | grep -q "^Host $HOSTNAME$"
  if [ $? -gt 0 ]; then
    echo "Host $HOSTNAME" >> $HOME/.ssh/config
    echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> $HOME/.ssh/config
  fi

  echorun knife solo prepare ubuntu@$HOSTNAME || exit $?

  touch $D_R/nodes/$HOSTNAME.setup-done
fi

echorun knife solo cook ubuntu@$HOSTNAME || exit $?
