#!/bin/bash

D_R=$(cd "$(dirname "$0")" || exit 1; pwd -P)
HOSTNAME="$1"
USERNAME="$2"

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
# shellcheck disable=SC1090
source "$D_R/functions.sh" || exit $?

cd "$D_R" || exit $?
bundle install -j "$(nproc)" || exit $?

if [ ! -f "$D_R/nodes/$HOSTNAME.setup-done" ]; then
  setup_local_ssh_key "$HOSTNAME" || exit $?

  ssh "$USERNAME@$HOSTNAME" 'mkdir ~/.ssh/'
  echorun scp "$HOME/.ssh/id_rsa_$HOSTNAME.pub" "$USERNAME@$HOSTNAME:~/.ssh/authorized_keys" || exit $?

  if ! (grep -q "^Host $HOSTNAME$" "$HOME/.ssh/config"); then
    echo "Host $HOSTNAME" >> "$HOME/.ssh/config"
    echo "  IdentityFile ~/.ssh/id_rsa_$HOSTNAME" >> "$HOME/.ssh/config"
  fi

  echorun knife solo prepare "$USERNAME@$HOSTNAME" || exit $?

  touch "$D_R/nodes/$HOSTNAME.setup-done"
fi

if ! (ssh "$USERNAME@$HOSTNAME" which git &>/dev/null); then
  echorun ssh "$USERNAME@$HOSTNAME" sudo apt-get install git -y || exit $?
fi

echorun knife solo cook "$USERNAME@$HOSTNAME" || exit $?
