#!/bin/bash

edit=1

if [ -L $0 ] ; then
  DIR=$(dirname $(readlink -f $0)) ;
else
  DIR=$(dirname $0) ;
fi
cd $DIR

case "$1" in
  "-f")
    edit=0
    shift
    ;;
esac

DropboxON=$(ps -A | grep -c dropbox)
if [[ $DropboxON == "0" ]]; then
  dropboxd &
else
  echo "dropbox is already running"
fi
#sleep 5
#git pull

echo
grep -r --exclude='TODO' "TODO" * > TODO
wc -l TODO
echo
#work work work

if [ $edit = 1 ]; then
  if ! [ -e $1 ] ; then
    vim $1
  else
    vim
  fi
fi

git commit -a -m "automatic commit"
git push
