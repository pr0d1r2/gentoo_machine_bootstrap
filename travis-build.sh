#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`
export PATH="$D_R:$PATH"

source $D_R/functions.sh || exit $?

THE_HOSTNAME="127.0.0.1"

echorun setup_local_ssh_key default || exit $?
echorun cp ~/.ssh/id_rsa_default.pub ~/.ssh/authorized_keys || exit $?

echorun cp ~/.ssh/id_rsa_default ~/.ssh/id_rsa_$THE_HOSTNAME || exit $?
echorun cp ~/.ssh/id_rsa_default.pub ~/.ssh/id_rsa_$THE_HOSTNAME.pub || exit $?

ssh-keyscan $THE_HOSTNAME >> ~/.ssh/known_hosts || exit $?

echorun bash ./setup_ubuntu.sh $THE_HOSTNAME || exit $?
