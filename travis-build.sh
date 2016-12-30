#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`
export PATH="$D_R:$PATH"

source $D_R/functions.sh || exit $?

setup_local_ssh_key default || exit $?
cp ~/.ssh/id_rsa_default.pub ~/.ssh/authorized_keys || exit $?

sh ./setup_ubuntu.sh 127.0.0.1 || exit $?
