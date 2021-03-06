#!/usr/bin/env bash
#
# Bootstrap software installations with Ansible.


# Exit immediately if a command exists with a non-zero status.
set -e

#######################################
# Show CLI help information.
# Cannot use function name help, since help is a pre-existing command.
# Outputs:
#   Writes help information to stdout.
#######################################
usage() {
  case "$1" in
    bootstrap)
      cat 1>&2 <<EOF
Bootware bootstrap
Boostrap install computer software

USAGE:
    bootware bootstrap [OPTIONS]

OPTIONS:
    -c, --config <PATH>             Path to bootware user configuation file
    -d, --dev                       Run bootstrapping in development mode
    -h, --help                      Print help information
        --no-passwd                 Do not ask for user password
        --no-setup                  Skip Ansible installation
    -s, --skip-tags <TAG-LIST>      Ansible playbook tag list
    -t, --tags <TAG-LIST>           Ansible playbook tag list
EOF
      ;;
    config)
      cat 1>&2 <<EOF
Bootware config
Download default Bootware configuration file

USAGE:
    bootware config [OPTIONS]

OPTIONS:
    -h, --help              Print help information
    -d, --dest <PATH>       Path to alternate download destination
        --empty             Write empty configuration file
    -s, --source <URL>      URL to configuration file
EOF
      ;;
    main)
      cat 1>&2 <<EOF
$(version)
Boostrapping software installer

USAGE:
    bootware [OPTIONS] [SUBCOMMAND]

OPTIONS:
    -h, --help       Print help information
    -v, --version    Print version information

SUBCOMMANDS:
    bootstrap        Boostrap install computer software
    config           Generate default Bootware configuration file
    setup            Install dependencies for Bootware
    update           Update Bootware to latest version
EOF
      ;;
    setup)
      cat 1>&2 <<EOF
Bootware setup
Install dependencies for Bootware

USAGE:
    bootware setup [OPTIONS]

OPTIONS:
    -h, --help      Print help information
EOF
      ;;
    update)
      cat 1>&2 <<EOF
Bootware update
Update Bootware to latest version

USAGE:
    bootware update [OPTIONS]

OPTIONS:
    -h, --help                  Print help information
    -v, --version <VERSION>     Version override for update
EOF
      ;;
  esac
}

#######################################
# Assert that command can be found in system path.
# Will exit script with an error code if command is not in system path.
# Arguments:
#   Command to check availabilty.
# Outputs:
#   Writes error message to stderr if command is not in system path.
#######################################
assert_cmd() {
  # Flags:
  #   -v: Only show file path of command.
  if ! command -v "$1" > /dev/null; then
    error "Cannot find required $1 command on computer."
  fi
}

# Bootstrap subcommand.
bootstrap() {
  # Dev null is never a normal file.
  local _config_path="/dev/null"
  local _no_setup
  local _playbook
  local _pull="1"
  local _skip_tags
  local _tags
  local _use_passwd="1"

  # Parse command line arguments.
  for arg in "$@"; do
    case "$arg" in
      -h|--help)
        usage "bootstrap"
        exit 0
        ;;
      -c|--config)
        _config_path="$2"
        shift 2
        ;;
      -d|--dev)
        _pull=""
        _playbook="playbook"
        shift 1
        ;;
      --no-passwd)
        _use_passwd=""
        shift 1
        ;;
      --no-setup)
        _no_setup="1"
        shift 1
        ;;
      -s|--skip|--skip-tags)
        _skip_tags="$2"
        shift 2
        ;;
      -t|--tags)
        _tags="$2"
        shift 2
        ;;
      *)
        ;;
    esac
  done

  if [[ ! "$_no_setup" ]]; then
    setup
  fi

  find_config_path "$_config_path"
  _config_path="$RET_VAL"

  echo "Executing Ansible ${_playbook:-pull}..."
  echo "Enter your user account password if prompted."

  ansible-${_playbook:-pull}  \
    ${_use_passwd:+--ask-become-pass} \
    ${_playbook:+--connection local} \
    --extra-vars "ansible_python_interpreter=auto_silent" \
    --extra-vars "user_account=${USER:-root}" \
    --extra-vars "@$_config_path" \
    --inventory 127.0.0.1, \
    ${_skip_tags:+--skip-tags "$_skip_tags"} \
    ${_tags:+--tags "$_tags"} \
    ${_pull:+--url "https://github.com/wolfgangwazzlestrauss/bootware.git"} \
    main.yaml
}

#######################################
# Subcommand to generate or download Bootware configuration file.
# Globals:
#   HOME
# Arguments:
#   Parent directory of Bootware script.
# Outputs:
#   Writes status information to stdout.
#######################################
config() {
  local src_url="https://raw.githubusercontent.com/wolfgangwazzlestrauss/bootware/master/host_vars/bootware.yaml"
  local dst_file="${HOME}/.bootware/config.yaml"
  local empty_cfg=0

  assert_cmd mkdir

  # Parse command line arguments.
  for arg in "$@"; do
    case "$arg" in
      -h|--help)
        usage "config"
        exit 0
        ;;
      -d|--dest)
        dst_file="$2"
        shift 2
        ;;
      -e|--empty)
        empty_cfg=1
        shift 1
        ;;
      -s|--source)
        src_url="$2"
        shift 2
        ;;
      *)
        ;;
    esac
  done

  mkdir -p "$(dirname "${dst_file}")"

  if [[ ${empty_cfg} == 1 ]]; then
    echo "Writing empty configuration file to ${dst_file}..."
    echo "mock_data: true" > "${dst_file}"
  else
    assert_cmd curl

    echo "Downloading configuration file to ${dst_file}..."

    # Download default configuration file.
    #
    # FLAGS:
    #   -L: Follow redirect request.
    #   -S: Show errors.
    #   -f: Use archive file. Must be third flag.
    #   -o <path>: Write output to path instead of stdout. 
    curl -LSfs "${src_url}" -o "${dst_file}"
  fi
}

#######################################
# Update dnf package lists.
#
# DNF's check-update command will give a 100 exit code if there are packages
# available to update. Thus both 0 and 100 must be treated as successfully
# exit codes.
#
# Arguments:
#   Whether to use sudo command.
#######################################
dnf_check_update() {
  ${1:+sudo} dnf check-update || { code=$?; [ ${code} -eq 100 ] && return 0; return ${code}; }
}

#######################################
# Print error message and exit script with error code.
# Outputs:
#   Writes error message to stderr if command is not in system path.
#######################################
error() {
  printf 'Error: %s\n' "$1" >&2
  exit 1
}

#######################################
# Find path of Bootware configuation file.
# Globals:
#   BOOTWARE_CONFIG
#   HOME
# Arguments:
#   User supplied configuration path.
# Outputs:
#   Writes error message to stderr if unable to find configuration file.
# Retunrs:
#   Configuration file path.
#######################################
find_config_path() {
  if test -f "$1" ; then
    RET_VAL="$1"
  elif test -f "$(pwd)/bootware.yaml" ; then
    RET_VAL="$(pwd)/bootware.yaml"
  elif [[ -n "${BOOTWARE_CONFIG}" ]] ; then
    RET_VAL="$BOOTWARE_CONFIG"
  elif test -f "$HOME/.bootware/config.yaml" ; then
    RET_VAL="$HOME/.bootware/config.yaml"
  else
    error "Unable to find Bootware configuation file."
  fi

  echo "Using $RET_VAL as configuration file."
}

# Configure boostrapping services and utilities.
setup() {
  local arg
  local os_type

  assert_cmd uname

  # Parse command line arguments.
  for arg in "$@"; do
    case "${arg}" in
      -h|--help)
        usage "setup"
        exit 0
        ;;
      *)
        ;;
    esac
  done

  # Get operating system.
  #
  # FLAGS:
  #     -s: Print the kernel name.
  os_type=$(uname -s)

  case "${os_type}" in
    Darwin)
      setup_macos
      ;;
    Linux)
      setup_linux
      ;;
    *)
      error "Operting system ${os_type} is not supported."
      ;;
  esac

  ansible-galaxy collection install community.general > /dev/null
  ansible-galaxy collection install community.windows > /dev/null
}

# Configure boostrapping services and utilities for Arch distributions.
setup_arch() {
  # Install dependencies for Bootware.
  #
  # dpkg -l does not always return the correct exit code. dpkg -s does. See
  # https://github.com/bitrise-io/bitrise/issues/433#issuecomment-256116057
  # for more information.
  #
  # Flags:
  #   -Q:
  #   -i:
  if ! pacman -Qi ansible &>/dev/null ; then
    echo "Installing Ansible..."
    ${1:+sudo} pacman --noconfirm -Suy
    ${1:+sudo} pacman --noconfirm -S ansible
  fi

  if ! pacman -Qi curl &>/dev/null ; then
    echo "Installing Curl..."
    ${1:+sudo} pacman --noconfirm -Suy
    ${1:+sudo} pacman -S --noconfirm curl
  fi

  if ! pacman -Qi git &>/dev/null ; then
    echo "Installing Git..."
    ${1:+sudo} pacman --noconfirm -Suy
    ${1:+sudo} pacman -S --noconfirm git
  fi
}

# Configure boostrapping services and utilities for Debian distributions.
setup_debian() {
  # Install dependencies for Bootware.
  #
  # dpkg -l does not always return the correct exit code. dpkg -s does. See
  # https://github.com/bitrise-io/bitrise/issues/433#issuecomment-256116057
  # for more information.
  #
  # Flags:
  #   -s:
  if ! dpkg -s ansible &>/dev/null ; then
    echo "Installing Ansible..."
    ${1:+sudo} apt-get -qq update
    ${1:+sudo} apt-get -qq install -y ansible python3-apt
  fi

  if ! dpkg -s curl &>/dev/null ; then
    echo "Installing Curl..."
    ${1:+sudo} apt-get -qq update
    ${1:+sudo} apt-get -qq install -y curl
  fi

  if ! dpkg -s git &>/dev/null ; then
    echo "Installing Git..."
    ${1:+sudo} apt-get -qq update
    ${1:+sudo} apt-get -qq install -y git
  fi
}

# Configure boostrapping services and utilities for Linux.
setup_linux() {
  local use_sudo

  if [[ ${EUID} != 0 ]]; then
    use_sudo=1
  fi

  # Install dependencies for Bootware base on available package manager.
  #
  # Flags:
  #   -v: Only show file path of command.
  if command -v pacman &>/dev/null ; then
    setup_arch ${use_sudo}
  elif command -v apt-get &>/dev/null ; then
    setup_debian ${use_sudo}
  elif command -v dnf &>/dev/null ; then
    setup_redhat ${use_sudo}
  else
    error "Unable to find supported package manager."
  fi
}

# Configure boostrapping services and utilities for MacOS.
setup_macos() {
  assert_cmd curl

  # Install XCode command line tools if not already installed.
  #
  # Homebrew depends on the XCode command line tools.
  if ! xcode-select -p &>/dev/null ; then
    echo "Installing command line tools for XCode..."
    sudo xcode-select --install
  fi

  # Install Homebrew if not already installed.
  #
  # FLAGS:
  #     -L: Follow redirect request.
  #     -S: Show errors.
  #     -f: Fail silently on server errors.
  #     -s: Disable progress bars.
  if ! command -v brew > /dev/null; then
    echo "Installing Homebrew..."
    curl -LSfs "https://raw.githubusercontent.com/Homebrew/install/master/install.sh" | bash
  fi

  # Install Ansible if not already installed.
  if ! brew list ansible &>/dev/null ; then
    echo "Installing Ansible..."
    brew install ansible
  fi

  # Install Git if not already installed.
  if ! brew list git &>/dev/null ; then
    echo "Installing Git.."
    brew install git
  fi
}

# Configure boostrapping services and utilities for Red Hat distributions.
setup_redhat() {
  # Install dependencies for Bootware.
  if ! dnf list installed ansible &>/dev/null ; then
    echo "Installing Ansible..."
    dnf_check_update "$1"
    ${1:+sudo} dnf install -y ansible
  fi

  if ! dnf list installed curl &>/dev/null ; then
    echo "Installing Curl..."
    dnf_check_update "$1"
    ${1:+sudo} dnf install -y curl
  fi

  if ! dnf list installed git &>/dev/null ; then
    echo "Installing Git..."
    dnf_check_update "$1"
    ${1:+sudo} dnf install -y git
  fi
}

#######################################
# Subcommand to update Bootware script
# Arguments:
#   Parent directory of Bootware script.
# Outputs:
#   Writes status information and updated Bootware version to stdout.
#######################################
update() {
  local dst_file
  local src_url
  local use_sudo
  local version="master"

  assert_cmd chmod
  assert_cmd curl

  # Cannot use realpath command, since it is not built into MacOS.
  #
  # Flags:
  #   -P: Resolve any symbolic links in the path.
  dst_file="$(cd "$(dirname "$0")"; pwd -P)/$(basename "$0")"

  # Parse command line arguments.
  for arg in "$@"; do
    case "${arg}" in
      -h|--help)
        usage "update"
        exit 0
        ;;
      -v|--version)
        shift 1
        version="$2"
        ;;
      *)
        ;;
    esac
  done

  src_url="https://raw.githubusercontent.com/wolfgangwazzlestrauss/bootware/${version}/bootware.sh"

  # Use sudo for system installation if user is not root.
  #
  # Flags:
  #   -O: True if file is owned by the current user.
  if [[ ! -O "${dst_file}" || ${EUID} != 0 ]]; then
    assert_cmd sudo
    use_sudo=1
  fi

  echo "Updating Bootware..."

  ${use_sudo:+sudo} curl -LSfs "${src_url}" -o "${dst_file}"
  ${use_sudo:+sudo} chmod 755 "${dst_file}"

  echo "Updated to version $(bootware --version)."
}

#######################################
# Print Bootware version string.
# Outputs:
#   Bootware version string.
#######################################
version() {
  echo "Bootware 0.1.0"
}

#######################################
# Script entrypoint.
#######################################
main() {
  # Parse command line arguments.
  for arg in "$@"; do
    case "$arg" in
      config)
        shift 1
        config "$@"
        exit 0
        ;;
      bootstrap)
        shift 1
        bootstrap "$@"
        exit 0
        ;;
      setup)
        shift 1
        setup "$@"
        exit 0
        ;;
      update)
        shift 1
        update "$@"
        exit 0
        ;;
      -v|--version)
        version
        exit 0
        ;;
      *)
        ;;
    esac
  done

  usage "main"
}

main "$@"
