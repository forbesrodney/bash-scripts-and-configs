#!/bin/bash

#
# The MIT License (MIT)
#
# Copyright (c) 2015 Snakepit Software
# Author: Rodney C Forbes    <5n4k3@snakepitsoftware.com>
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.
#

# We still need this.
# [[ -n "$WINDIR" ]]
function windows() { [ "${OS}" = "Windows_NT" ]; }

# Cross-platform symlink function. With one parameter, it will check
# whether the parameter is a symlink. With two parameters, it will create
# a symlink to a file or directory, with syntax: link $linkname $target
function link() {
    local link_target=$1
    local link_source=$2

    if [ $# -lt 2 ]; then
        # Check link
        if windows; then
            fsutil reparsepoint query "${link_source}" > /dev/null
        else
            [ -h "${link_source}" ]
        fi
    else
        # Create link
        if windows; then
            # Note : Windows needs to be told if it's a directory or not
            # Note : We need to convert `/` to `\`
            # Note : The parameters to Windows mklink command are backwards
            if [ -d "${link_target}" ]; then
                cmd <<< "mklink /D \"${link_source}\" \"${link_target//\//\\}\"" > /dev/null
            else
                cmd <<< "mklink \"${link_source}\" \"${link_target//\//\\}\"" > /dev/null
            fi
        else
            ln -s "${link_target}" "${link_source}"
        fi
    fi
}

# Remove a link, cross-platform.
function rmlink() {
    local link_source=$1

    if windows; then
        # Again, Windows needs to be told if it's a file or directory.
        if [ -d "${link_source}" ]; then
            rmdir "${link_source}";
        else
            rm "${link_source}"
        fi
    else
        rm "${link_source}"
    fi
}

if [ "$#" -ne 0 ]; then
    if [ $# -eq 1 ] && [ $1 = "--test" ]; then
        echo "TESTING SCRIPT LOGIC"
    else
        echo "Usage : $0 [--test]"
        exit
    fi
fi

# Not as portable as I'd like
#SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

SCRIPTDIR=`dirname "$0"`
SCRIPTDIR=`exec 2>/dev/null;(cd -- "$SCRIPTDIR") && cd -- "$SCRIPTDIR"|| cd "$SCRIPTDIR"; unset PWD; /usr/bin/pwd || /bin/pwd || pwd`
if windows; then
    SCRIPTDIR=C:${SCRIPTDIR:2}
fi
#echo ${SCRIPTDIR}

#KERNEL_NAME=$(uname -s | tr "[:upper:]" "[:lower:]")

#
# Configure manifest information
#

# Non shell specific
DOTS="digrc nslookuprc nofinger gitignore vimrc gitconfig_common gitconfig_mac gitconfig_linux gitconfig_windows astylerc inputrc"
# BASH shell
DOTS="${DOTS} bash_profile bashrc bash_logout bash_alias"
# SH shell (including ash, dash, ...)
DOTS="${DOTS} profile"
# CSH (including tcsh)
#DOTS="${DOTS} .cshrc .login .logout .alias"

SCRIPTS="list_open_ports.sh"
#if [ ${KERNEL_NAME} = "darwin" ]; then
#    SCRIPTS="${SCRIPTS} ${PLATFORM}/access.sh ${OS}/kick.sh ${OS}/free.py"
#fi
#if [ ${KERNEL_NAME} = "linux" ]; then
#    SCRIPTS="${SCRIPTS}"
#fi

pushd ~ > /dev/null
# Link the dot files
for f in ${DOTS}; do
    if [ -L .${f} ]; then
        echo "Removing old link : ~/.${f}"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            rmlink .${f}
        fi
    else
        if [ -e .${f} ]; then
            echo "Skipping ~/.${f} : file exists and is not a symbolic link"
            continue
        fi
    fi

    echo "Creating new link : ~/.${f} -> ${SCRIPTDIR}/dots/${f}"
    if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
        link ${SCRIPTDIR}/dots/${f} .${f}
    fi
done

# Create the directories
if ! [ -d bin ]; then
    if ! [ -e bin ]; then
        echo "Creating ~/bin"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            mkdir bin
            chmod 755 bin
        fi
    else
        echo "~/bin exists, but isn't a directory"
        exit
    fi
fi
#if ! [ -d bin/${KERNEL_NAME} ]; then
#    if ! [ -e bin/${KERNEL_NAME} ]; then
#        echo "Creating ~/bin/${KERNEL_NAME}"
#        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
#            mkdir -p bin/${KERNEL_NAME}
#            chmod 755 bin/${KERNEL_NAME}
#        fi
#    else
#        echo "~/bin/${KERNEL_NAME} exists, but isn't a directory"
#        exit
#    fi
#fi

# Link the scripts
for f in ${SCRIPTS}; do
    if [ -L bin/${f} ]; then
        echo "Removing old link : ~/bin/${f}"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            rm bin/${f}
        fi
    else
        if [ -e bin/${f} ]; then
            echo "Skipping ~/bin/${f} : file exists and is not a symbolic link"
            continue
        fi
    fi

    echo "Creating new link : ~/bin/${f} -> ${SCRIPTDIR}/scripts/${f}"
    if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
        link ${SCRIPTDIR}/scripts/${f} bin/${f}
    fi
done
popd > /dev/null

echo
echo "Installing 3rd party bits, ..."
echo "~/.gdbinit -"
curl https://raw.githubusercontent.com/gdbinit/Gdbinit/master/gdbinit > ~/.gdbinit
chmod 644 ~/.gdbinit
echo "~/bin/git-prompt.sh -"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/bin/git-prompt.sh
chmod 755 ~/bin/git-prompt.sh

echo
echo "**************************************************************"
echo "* Don't forget to copy and modify gitconfig to ~/.gitconfig. *"
echo "**************************************************************"
