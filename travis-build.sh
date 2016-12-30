#!/bin/sh

D_R=`cd \`dirname $0\` ; pwd -P`
export PATH="$D_R:$PATH"

source $D_R/functions.sh || return $?

setup_local_ssh_key default || exit $?
cp ~/.ssh/id_rsa_default.pub ~/.ssh/authorized_keys || return $?

sh ./setup_ubuntu.sh 127.0.0.1 || return $?
