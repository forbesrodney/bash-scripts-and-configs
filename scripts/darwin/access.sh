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

function usage {
	echo "Usage : ${0} {show|allow|deny} username"
        exit
}

if [[ $# -ne 2 ]]; then
	usage
fi

case $1 in
	"deny" )
		sudo dscl . -change /Users/$2 UserShell /bin/bash /usr/bin/false
		;;
	"allow" )
		sudo dscl . -change /Users/$2 UserShell /usr/bin/false /bin/bash
		;;
	"show" )
		sudo dscl . -read /Users/$2 UserShell
		;;
	* )
		usage
		;;
esac
