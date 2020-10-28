#!/bin/bash
set -x
set -euo pipefail

SCRIPT_DIR=$(dirname $0)

$SCRIPT_DIR/pack/ycm/opt/YouCompleteMe/install.py --clang-completer --clangd-completer --rust-completer --ninja

#DISTRIBUTOR_ID=$(lsb_release -i)

#if [ "$DISTRIBUTOR_ID" == "Distributor ID: openSUSE" ]; then
  #zypper install rtags
#elif [ "$DISTRIBUTOR_ID" == "Distributor ID: Ubuntu" ]; then
  #apt install rtags
#fi
