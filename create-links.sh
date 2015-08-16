#!/bin/sh

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

if [ "$#" -ne 0 ]; then
    if [ $# -eq 1 ] && [ $1 = "--test" ]; then
        echo "TESTING SCRIPT LOGIC"
    else
        echo "Usage : $0 [--test]"
        exit
    fi
fi

# Not as portable as I'd like
#SCRIPTDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

SCRIPTDIR=`dirname "$0"`
SCRIPTDIR=`exec 2>/dev/null;(cd -- "$SCRIPTDIR") && cd -- "$SCRIPTDIR"|| cd "$SCRIPTDIR"; unset PWD; /usr/bin/pwd || /bin/pwd || pwd`

OS=$(uname -s | tr "[:upper:]" "[:lower:]")

#
# Configure manifest information
#

# Non shell specific
DOTS="digrc nslookuprc nofinger gitignore vimrc"
# BASH shell
DOTS="${DOTS} bash_profile bashrc bash_logout bash_alias"
# SH shell (including ash, dash, ...)
DOTS="${DOTS} profile"
# CSH (including tcsh)
#DOTS="${DOTS} .cshrc .login .logout .alias"

SCRIPTS="list_open_ports.sh"
if [ ${OS} = "darwin" ]; then
    SCRIPTS="${SCRIPTS} access.sh kick.sh"
fi
if [ ${OS} = "linux" ]; then
    SCRIPTS="${SCRIPTS}"
fi

oldpath=`pwd`
cd ~
# Link the dot files
for f in ${DOTS}; do
    if [ -L .${f} ]; then
        echo "Removing old link : .${f}"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            rm .${f}
        fi
    else
        if [ -e .${f} ]; then
            echo "Skipping .${f} : file exists and is not a symbolic link"
            continue
        fi
    fi

    echo "Creating new link : .${f} -> ${SCRIPTDIR}/dots/${f}"
    if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
        ln -s ${SCRIPTDIR}/dots/${f} ~/.${f}
    fi
done

# Create the directories
if ! [ -d bin ]; then
    if ! [ -e bin ]; then
        echo "Creating bin"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            mkdir bin
    fi
    else
        echo "bin exists, but isn't a directory"
        exit
    fi
fi
if ! [ -d bin/${OS} ]; then
    if ! [ -e bin/${OS} ]; then
        echo "Creating bin/${OS}"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            mkdir -p bin/${OS}
        fi
    else
        echo "bin/${OS} exists, but isn't a directory"
        exit
    fi
fi

# Link the scripts
for f in ${SCRIPTS}; do
    if [ -L bin/${f} ]; then
        echo "Removing old link : bin/${f}"
        if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
            rm bin/${f}
        fi
    else
        if [ -e bin/${f} ]; then
            echo "Skipping bin/${f} : file exists and is not a symbolic link"
            continue
        fi
    fi

    echo "Creating new link : bin/${f} -> ${SCRIPTDIR}/scripts/${f}"
    if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
        ln -s ${SCRIPTDIR}/scripts/${f} ~/bin/${f}
    fi
done
cd ${oldpath}
