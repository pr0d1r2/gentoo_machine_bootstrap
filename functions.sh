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
  if [ ! -f $HOME/.ssh/id_rsa_$1 ]; then
    echo ssh-keygen
    ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$1 -C $1@`hostname` -a 500 -N '' || return $?
  fi
}

function setup_local_ssh_key() {
  if [ ! -f $HOME/.ssh/id_rsa_$1 ]; then
    ssh -V 2>&1 | grep -q "^OpenSSH"
    if [ $? -eq 0 ]; then
      local setup_local_ssh_key_SSH_VERSION_MAJOR=`ssh -V 2>&1 | cut -f 1 -d , | cut -f 2 -d _ | cut -f 1 -d .`
      local setup_local_ssh_key_SSH_VERSION_MINOR=`ssh -V 2>&1 | cut -f 1 -d , | cut -f 2 -d _ | cut -f 2 -d . | cut -f 1 -d p`
      if [ $setup_local_ssh_key_SSH_VERSION_MAJOR -eq 6 ]; then
        if [ $setup_local_ssh_key_SSH_VERSION_MINOR -lt 5 ]; then
          ssh_keygen_old_ssh default || exit $?
        fi
      elif [ $setup_local_ssh_key_SSH_VERSION_MAJOR -lt 6 ]; then
        ssh_keygen_old_ssh default || exit $?
      else
        echo ssh-keygen
        # TODO: knife-solo needs to first support `net-ssh` 4+ (for `-o` new format key)
        # ssh-keygen -b 4096 -f $HOME/.ssh/id_rsa_$1 -C $1@`hostname` -o -a 500 -N '' || return $?
        ssh_keygen_old_ssh $1 || return $?
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
  eval `ssh-agent -s` || return $?
  ssh-add ~/.ssh/id_rsa_$1 || return $?
}

function sha256hash() {
  shasum -a 256 $1 | cut -f 1 -d ' '
}

function sha512hash() {
  shasum -a 512 $1 | cut -f 1 -d ' '
}

function md5hash() {
  case `uname` in
    Darwin)
      echo $(md5 $1 | cut -f 2 -d =)
      ;;
    *)
      md5sum $1 | cut -f 1 -d ' '
      ;;
  esac
}

function confirm_checksum() {
  local confirm_checksum_SUM=`sha256hash $1`
  case $confirm_checksum_SUM in
    $2)
      ;;
    *)
      echo "Bad checksum for $1 (REMOVING) [expected: $2, was $confirm_checksum_SUM]"
      echo
      echo "Calculated other sums (you may use them to check with DIGESTS file in case you are updating):"
      echo "SHA512: `sha512hash $1`"
      echo "MD5: `md5hash $1`"
      rm -f $1
      return 101
      ;;
  esac
}

function download_with_checksum() {
  local download_with_checksum_BASENAME=`basename $1`
  if [ ! -d $D_R/packer_cache ]; then
    mkdir -p $D_R/packer_cache || return $?
  fi
  cd $D_R/packer_cache || return $?
  if [ ! -f $download_with_checksum_BASENAME ]; then
    case $3 in
      --wget)
        wget $1 || return $?
        ;;
      *)
        axel $1 || return $?
        ;;
    esac
  fi
  confirm_checksum `pwd -P`/$download_with_checksum_BASENAME $2 || return $?
  cd - &>/dev/null
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
      Linux)
        case $ensure_command_COMMAND in
          packer)
            download_with_checksum \
              https://releases.hashicorp.com/packer/0.12.1/packer_0.12.1_linux_amd64.zip \
              456e6245ea95705191a64e0556d7a7ecb7db570745b3b4b2e1ebf92924e9ef95 \
              --wget || return 5005
            echorun unzip $D_R/packer_cache/packer_0.12.1_linux_amd64.zip || retutn 5006
            ;;
          *)
            echo "Please install package for command $ensure_command_COMMAND"
            return 8472
            ;;
        esac
        ;;
    esac
  fi
}
