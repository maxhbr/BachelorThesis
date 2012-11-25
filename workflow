#!/bin/bash

edit=1

case "$1" in
  "-f")
      edit=0
    shift
    ;;
esac

if [ -L $0 ] ; then
  DIR=$(dirname $(readlink -f $0)) ;
else
  DIR=$(dirname $0) ;
fi
cd $DIR

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

if [ $edit = 0 ]; then
  vim
fi

git commit -a -m "automatic commit"
git push
