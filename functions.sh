UNAME=`uname`

function echorun() {
  echo "$@"
  $@ || return $?
}

function cpu_num() {
  case $UNAME in
    Darwin)
      /usr/sbin/sysctl -n hw.ncpu
      ;;
    Linux)
      nproc
      ;;
    *)
      return 1
      ;;
  esac
}

function bundler_threads() {
  expr `cpu_num` \* 4
}

function ssh_keygen_old_ssh() {
  echorun ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$1 -C $1@`hostname` -a 500 || return $?
}

function setup_local_ssh_key() {
  if [ ! -f $HOME/.ssh/id_rsa_$1 ]; then
    ssh -V | grep -q "^OpenSSH"
    if [ $? -eq 0 ]; then
      local setup_local_ssh_key_SSH_VERSION_MAJOR=`ssh -V | cut -f 1 -d , | cut -f 2 -d _ | cut -f 1 -d .`
      local setup_local_ssh_key_SSH_VERSION_MINOR=`ssh -V | cut -f 1 -d , | cut -f 2 -d _ | cut -f 2 -d . | cut -f 1 -d p`
      if [ $setup_local_ssh_key_SSH_VERSION_MAJOR -eq 6 ]; then
        if [ $setup_local_ssh_key_SSH_VERSION_MINOR -lt 5 ]; then
          ssh_keygen_old_ssh || exit $?
        fi
      elif [ $setup_local_ssh_key_SSH_VERSION_MAJOR -lt 6 ]; then
        ssh_keygen_old_ssh || exit $?
      else
        echorun ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$1 -C $1@`hostname` -o -a 500 || return $?
      fi
    else
      echo "There is no openssh!"
      return 2002
    fi
  fi

  if [ ! -d $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default ]; then
    mkdir -p $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default || return $?
  fi
  cp ~/.ssh/id_rsa_$1.pub $D_R/chefrepo/site-cookbooks/gentoo_machine_bootstrap/files/default/id_rsa_$1.pub || return $?
  ssh-add ~/.ssh/id_rsa_$1 || return $?
}

function ensure_command() {
  local ensure_command_COMMAND=$1
  case $2 in
    "")
      local ensure_command_PACKAGE="$ensure_command_COMMAND"
      ;;
    *)
      local ensure_command_PACKAGE="$2 $3 $4 $5 $6 $7 $8 $9"
      ;;
  esac
  which $ensure_command_COMMAND &>/dev/null
  if [ $? -gt 0 ]; then
    case $UNAME in
      Darwin)
        echorun brew install $ensure_command_PACKAGE || return $?
        ;;
      *)
        echo "Please install package for command $ensure_command_COMMAND"
        return 8472
        ;;
    esac
  fi
}
