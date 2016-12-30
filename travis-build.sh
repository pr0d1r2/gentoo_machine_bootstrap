#!/bin/bash

D_R=`cd \`dirname $0\` ; pwd -P`
export PATH="$D_R:$PATH"

source $D_R/functions.sh || exit $?

THE_HOSTNAME="127.0.0.1"

setup_local_ssh_key $THE_HOSTNAME || exit $?
cp ~/.ssh/id_rsa_$THE_HOSTNAME.pub ~/.ssh/authorized_keys || exit $?

bash ./setup_ubuntu.sh $THE_HOSTNAME || exit $?
