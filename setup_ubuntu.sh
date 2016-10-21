#!/bin/sh

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


echorun knife solo prepare ubuntu@$HOSTNAME || return $?
echorun knife solo cook ubuntu@$HOSTNAME || return $?
