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
ssh root@$HOSTNAME 'mkdir ~/.ssh/'
echorun scp $HOME/.ssh/id_rsa_$HOSTNAME.pub root@$HOSTNAME:~/.ssh/authorized_keys || return $?

cat $HOME/.ssh/config | grep -q "^Host $HOSTNAME$"
if [ $? -gt 0 ]; then
  echo "Host $HOSTNAME" >> $HOME/.ssh/config
  echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> $HOME/.ssh/config
fi

ssh-add ~/.ssh/id_rsa_$HOSTNAME

exit 3

echorun ssh root@$HOSTNAME \
  wget https://gist.githubusercontent.com/pr0d1r2/ee973ea67936f197850bdf751a0c95f5/raw/ac819b80cfbade0857f9f29956dc41d7c18b5412/install.sh

emerge --autounmask-write "=dev-lang/ruby-2.3.1"
emerge --autounmask y  --autounmask-write y "=dev-lang/ruby-2.3.1"



echorun knife solo prepare root@$HOSTNAME || return $?

echorun ssh root@$HOSTNAME gem install chef -v 12.15.19
