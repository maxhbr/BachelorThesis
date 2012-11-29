#!/bin/bash

if [ -L $0 ] ; then
  DIR=$(dirname $(readlink -f $0)) ;
else
  DIR=$(dirname $0) ;
fi
cd $DIR

test -f main.tex || return

if [[ $1 == "nDP" ]] ; then
  shift
  echo "no DP"
else
  DropboxON=$(ps -A | grep -c dropbox)
  if [[ $DropboxON == "0" ]]; then
    echo "dropbox started, pid:"
    dropboxd &
    echo $!
  else
    echo "dropbox is already running"
  fi
fi
echo

#sleep 5
#git pull

grep -r --exclude='TODO' "TODO" * > TODO
wc -l TODO
echo


if [[ $# -gt 0 ]] ; then
  case "$1" in
    "mk")
      latexmk -pvc -pdf main.tex

      echo
      git commit -a -m "automatic commit"
      git push
      ;;
    "rb")
      rubber --ps --pdf main.tex

      echo
      git commit -a -m "automatic commit"
      git push
      ;;
    "vim")
      vim

      echo
      git commit -a -m "automatic commit"
      git push
      ;;
  esac
fi
