#!/bin/bash

D_R=$(cd "$(dirname "$0")" || exit 1; pwd -P)
export PATH="$D_R:$PATH"

# shellcheck disable=SC1090
source "$D_R/functions.sh" || exit $?

THE_HOSTNAME="127.0.0.1"

echorun setup_local_ssh_key default || exit $?
echorun cp "$HOME/.ssh/id_rsa_default.pub" "$HOME/.ssh/authorized_keys" || exit $?

echorun cp "$HOME/.ssh/id_rsa_default" "$HOME/.ssh/id_rsa_$THE_HOSTNAME" || exit $?
echorun cp "$HOME/.ssh/id_rsa_default.pub" "$HOME/.ssh/id_rsa_$THE_HOSTNAME.pub" || exit $?

ssh-keyscan "$THE_HOSTNAME" >> "$HOME/.ssh/known_hosts" || exit $?

echorun bash ./setup_ubuntu.sh "$THE_HOSTNAME" "$(whoami)" || exit $?
