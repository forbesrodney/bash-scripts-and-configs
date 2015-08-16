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

#
# Configure files
#

# BASH
DOTS="${DOTS} bash_profile bashrc bash_logout bash_alias"
# SH
DOTS="${DOTS} profile"
# CSH
#DOTS="${DOTS} .cshrc .login .logout .alias"
# Other
DOTS="${DOTS} digrc nslookuprc nofinger gitignore"

oldpath=`pwd`
cd ~
for f in ${DOTS}; do
    if [ -e .${f} ]; then
        if ! [ -h .${f} ]; then
            echo "Skipping .${f} : file exists and is not a symbolic link"
            continue
        fi
        if [ -h .${f} ]; then
            echo "Removing old link : .${f}"
            if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
                rm ~/.${f}
            fi
        fi
    fi

    echo "Creating new link : .${f} -> ${SCRIPTDIR}/dots/${f}"
    if [ $# -ne 1 ] || ! [ $1 = "--test" ]; then
        ln -s ${SCRIPTDIR}/dots/${f} ~/.${f}
    fi
done
cd ${oldpath}
