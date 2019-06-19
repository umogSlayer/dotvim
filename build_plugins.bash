#!/bin/bash
set -x
set -euo pipefail

SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/bundle/YouCompleteMe/install.py --clang-completer --clangd-completer --ninja

#DISTRIBUTOR_ID=$(lsb_release -i)

#if [ "$DISTRIBUTOR_ID" == "Distributor ID: openSUSE" ]; then
  #zypper install rtags
#elif [ "$DISTRIBUTOR_ID" == "Distributor ID: Ubuntu" ]; then
  #apt install rtags
#fi
