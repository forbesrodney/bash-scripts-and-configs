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

TEST_LOGIC=0
PROFILE="home"

if [ "${#}" -ne 0 ]; then
  if [ "${#}" -eq 1 ] || [ "${#}" -eq 2 ] && [ "${1}" = "--test" ]; then
    echo "TESTING SCRIPT LOGIC"
    TEST_LOGIC=1
    shift
  fi

  if [ "${#}" -eq 1 ]; then
    PROFILE=${1}
  else
    echo "Usage : ${0} [--test] [profile]"
    exit
  fi
fi

# We still need this.
# [[ -n "$WINDIR" ]]
function windows() { [ "${OS}" = "Windows_NT" ]; }
KERNEL_NAME=$(uname -s | tr "[:upper:]" "[:lower:]")

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

# Not as portable as I'd like
#SCRIPTDIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)

SCRIPTDIR=`dirname "$0"`
SCRIPTDIR=`exec 2>/dev/null;(cd -- "$SCRIPTDIR") && cd -- "$SCRIPTDIR"|| cd "$SCRIPTDIR"; unset PWD; /usr/bin/pwd || /bin/pwd || pwd`
if windows; then
  SCRIPTDIR=C:${SCRIPTDIR:2}
fi
if [ ${TEST_LOGIC} -eq 1 ]; then
  echo ${SCRIPTDIR}
fi

#
# Configure manifest information
#

declare -a DOTS
declare -a SCRIPTS
declare -a LAYOUTS

# Non shell specific
DOTS=(digrc nslookuprc nofinger gitignore vimrc gitconfig gitconfig_common gitconfig_mac gitconfig_linux gitconfig_windows astylerc inputrc tmux.conf bash_sessions_disable)
# BASH shell
DOTS+=(bash_profile bashrc bash_logout bash_alias)
# SH shell (including ash, dash, ...)
DOTS+=(profile)
# CSH (including tcsh)
#DOTS+=(.cshrc .login .logout .alias)

if ! windows; then
  SCRIPTS=(list_open_ports.sh yank.sh)
fi
#if [ ${KERNEL_NAME} = "darwin" ]; then
#  SCRIPTS+=(${PLATFORM}/access.sh ${OS}/kick.sh ${OS}/free.py)
#fi
#if [ ${KERNEL_NAME} = "linux" ]; then
#  SCRIPTS+=()
#fi

LAYOUTS=(SecureView.tmux Builder.tmux Linux_Kernel_Labs.tmux)

#
# Start installing stuff
#

pushd ~ > /dev/null
# Link the dot files
for f in ${DOTS[@]}; do
  src=.${f}
  dst=${SCRIPTDIR}/dots/${f}

  if [ -L ${src} ]; then
    echo "Removing old link : ${src}"
    if [ ${TEST_LOGIC} -eq 0 ]; then
      rmlink ${src}
    fi
  elif [ -e ${src} ]; then
    echo "Skipping ${src} : file exists and is not a symbolic link"
    continue
  fi

  if [ ! -f ${dst} ]; then
    if [ -f ${dst}--${PROFILE}--${OS} ]; then
      dst=${dst}--${PROFILE}--${OS}
    elif [ -f ${dst}--${PROFILE} ]; then
      dst=${dst}--${PROFILE}
    fi
  fi
  echo "Creating new link : ${src} -> ${dst}"
  if [ ${TEST_LOGIC} -eq 0 ]; then
    if [ -f ${dst} ]; then
      link ${dst} ${src}
    fi
  fi
done

#      mkdir -p bin/${KERNEL_NAME}
#      chmod 755 bin/${KERNEL_NAME}

# Link the scripts
mkdir -p bin
chmod 755 bin
for f in ${SCRIPTS[@]}; do
  src=bin/${f}
  dst=${SCRIPTDIR}/scripts/${f}

  if [ -L ${src} ]; then
    echo "Removing old link : ${src}"
    if [ ${TEST_LOGIC} -eq 0 ]; then
      rm ${src}
    fi
  elif [ -e ${src} ]; then
    echo "Skipping ${src} : file exists and is not a symbolic link"
    continue
  fi

  echo "Creating new link : ${src} -> ${dst}"
  if [ ${TEST_LOGIC} -eq 0 ]; then
    if [ -f ${dst} ]; then
      link ${dst} ${src}
    fi
  fi
done

# Link the layouts
mkdir -p ~/.tmux/layouts
chmod 755 ~/.tmux/layouts
for f in ${LAYOUTS[@]}; do
  src=.tmux/layouts/${f}
  dst=${SCRIPTDIR}/layouts/${f}

  if [ -L ${src} ]; then
    echo "Removing old link : ${src}"
    if [ ${TEST_LOGIC} -eq 0 ]; then
      rm ${src}
    fi
  elif [ -e ${src} ]; then
    echo "Skipping ${src} : file exists and is not a symbolic link"
    continue
  fi

  echo "Creating new link : ${src} -> ${dst}"
  if [ ${TEST_LOGIC} -eq 0 ]; then
    if [ -f ${dst} ]; then
      link ${dst} ${src}
    fi
  fi
done
popd > /dev/null

echo
echo "Installing 3rd party bits, ..."

echo "~/.gdbinit -"
curl https://raw.githubusercontent.com/gdbinit/Gdbinit/master/gdbinit > ~/.gdbinit
chmod 644 ~/.gdbinit
touch ~/.gdbinit.local

echo "~/.ctags -"
curl https://gist.githubusercontent.com/romainl/085b4db4a26a06ec7e16/raw/3f794d8be5bd36835d2c213b9d2aa2bae4559c0b/.ctags > ~/.ctags
chmod 644 ~/.ctags

echo "~/bin/git-prompt.sh -"
curl https://raw.githubusercontent.com/git/git/master/contrib/completion/git-prompt.sh > ~/bin/git-prompt.sh
chmod 755 ~/bin/git-prompt.sh

echo "~/bin/diff-so-fancy.sh -"
curl https://raw.githubusercontent.com/so-fancy/diff-so-fancy/master/third_party/build_fatpack/diff-so-fancy > ~/bin/diff-so-fancy
chmod 755 ~/bin/diff-so-fancy

if ! windows; then
  echo "~/.tmux/plugins/tpm -"
  mkdir -p ~/.tmux/plugins
  [ -e ~/.tmux/plugins/tpm ] && [ ! -d ~/.tmux/plugins/tpm ] && rm -rf ~/.tmux/plugins/tpm
  if [ ! -d ~/.tmux/plugins/tpm ]; then
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
  else
    pushd ~/.tmux/plugins/tpm > /dev/null
    git pull
    popd > /dev/null
  fi
  ~/.tmux/plugins/tpm/scripts/install_plugins.sh
  ~/.tmux/plugins/tpm/scripts/update_plugin.sh all
fi

echo "~/.vim/autoload/plug.vim -"
mkdir -p ~/.vim/autoload/
mkdir -p ~/.vim/tags/
curl -fLo ~/.vim/autoload/plug.vim https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
vim +PlugInstall +qall
vim +PlugUpdate +qall

