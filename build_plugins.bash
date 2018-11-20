#!/bin/bash
set -x
set -euo pipefail

SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/bundle/YouCompleteMe/install.py --clang-completer --ninja

pushd $SCRIPT_DIR/bundle/Command-T/ruby/command-t/ext/command-t
ruby extconf.rb
make
popd

#DISTRIBUTOR_ID=$(lsb_release -i)

#if [ "$DISTRIBUTOR_ID" == "Distributor ID: openSUSE" ]; then
  #zypper install rtags
#elif [ "$DISTRIBUTOR_ID" == "Distributor ID: Ubuntu" ]; then
  #apt install rtags
#fi
