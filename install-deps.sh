#!/bin/bash

KERNEL_NAME=$(uname -s | tr "[:upper:]" "[:lower:]")
if [ "${KERNEL_NAME}" = "linux" ]; then
  OS="$(cat /etc/os-release | grep ID_LIKE | cut -d "=" -f2)"
  function windows() { [ "${OS}" = "Windows_NT" ]; }
fi

# I don't know yet which of these package names are debian only. I don't
# have any RHEL systems to try this on.
COMMON_PKGS=(sudo build-essential gdb git wget curl vim global tmux xclip)
#exuberant-ctags cscope
#powerline fonts-powerline
#python3-docopt python3-jinja2
DEBIAN_PKGS=()
FEDORA_PKGS=()

pkg_install=""
declare -a pkg_list

# Set the current package installer
if [ "${KERNEL_NAME}" = "linux" ]; then
  pkg_list=${COMMON_PKGS}
  if [ "${OS}" = "debian" ]; then
    pkg_install="sudo apt-get install -y"
    pkg_list+=${DEBIAN_PKGS}
  elif [ "${OS}" = "rhel fedora" ]; then
    pkg_install="sudo yum install -y"
    pkg_list+=${FEDORA_PKGS}
  fi
fi

install_deps() {
  if [ "${KERNEL_NAME}" = "linux" ]; then
    if [ ! -z "${pkg_install}" ]; then
      for pkg in ${pkg_list}; do
        ${pkg_install} ${pkg}
      done
    fi
  elif [ "${KERNEL_NAME}" = "darwin" ]; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew bundle
  fi
}

prompt_user() {
  # List the packages that must be installed
  echo
  echo "The following dependencies must be installed"
  echo "------------------------------------------------"
  for pkg in ${pkg_list}; do
    echo ${pkg}
  done
  if [ "${KERNEL_NAME}" = "darwin" ]; then
    echo "brew"
  fi
  echo "------------------------------------------------"

  # Ask the user if the want to continue with the installation
  echo
  read -p "Continue y/n?" -n 1 -r
  echo
  if [[ ${REPLY} =~ ^[Nn]$ ]]; then
    exit 0
  fi
}

prompt_user
install_deps

