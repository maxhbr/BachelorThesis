#!/bin/bash

edit=1

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



case "$1" in
  "mk")
    latexmk -pvc -pdf main.tex
    edit=0
    shift
    ;;
  "rb")
    rubber --ps --pdf main.tex
    edit=0
    shift
    ;;
  "-f")
    edit=0
    shift
    ;;
esac
#work work work

if [ $edit = 1 ]; then
  vim
fi

git commit -a -m "automatic commit"
git push
