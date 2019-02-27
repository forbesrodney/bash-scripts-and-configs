#!/bin/bash

OS="$(cat /etc/os-release | grep ID_LIKE | cut -d "=" -f2)"
COMMON_PKGS="curl exuberant-ctags cscope tmux"
#powerline fonts-powerline
#python3-docopt python3-jinja2
DEBIAN_PKGS=""
FEDORA_PKGS=""

install_deps() {
    local pkg_install=""
    local pkg_list=""

    # Set the current package installer
    if [[ "$OS" == "debian" ]]; then
        pkg_install="sudo apt-get install -y "
        pkg_list="$DEBIAN_PKGS"
    else
        pkg_install="sudo yum install -y "
        pkg_list="$FEDORA_PKGS"
    fi

    # Install Common Packages
    for pkg in $COMMON_PKGS; do
        $pkg_install $pkg
    done

    # Install OS Specific Packages
    for pkg in $pkg_list; do 
        $pkg_install $pkg 
    done
}

prompt_user() {
    local all_packages="${COMMON_PKGS} ${DEBIAN_PKGS} ${FEDORA_PKGS}"

    # List the packages that must be installed
    echo
    echo "The following dependencies must be installed"
    echo "------------------------------------------------"
    for pkg in $all_packages; do
        echo $pkg
    done
    echo "------------------------------------------------"

    # Ask the user if the want to continue with the installation
    echo
    read -p "Continue y/n?" -n 1 -r
    echo 
    if [[ $REPLY =~ ^[Nn]$ ]]; then
        exit 0
    fi
}

prompt_user
install_deps
