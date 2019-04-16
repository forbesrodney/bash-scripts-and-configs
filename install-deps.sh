#!/bin/bash

OS="$(cat /etc/os-release | grep ID_LIKE | cut -d "=" -f2)"

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
pkg_list=${COMMON_PKGS}

# Set the current package installer
if [ "${OS}" = "debian" ]; then
  pkg_install="sudo apt-get install -y"
  pkg_list+=${DEBIAN_PKGS}
elif [ "${OS}" = "rhel fedora" ]; then
  pkg_install="sudo yum install -y"
  pkg_list+=${FEDORA_PKGS}
fi

install_deps() {
  if [ ! -z ${pkg_install} ]; then
    for pkg in ${pkg_list}; do
      ${pkg_install} ${pkg}
    done
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
