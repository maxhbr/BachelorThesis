#!/bin/bash

if [ -L $0 ] ; then
  DIR=$(dirname $(readlink -f $0)) ;
else
  DIR=$(dirname $0) ;
fi
cd $DIR

DropboxON=$(ps -A | grep -c dropbox)
if [[ $DropboxON == "0" ]]; then
  dropboxd &
fi
#sleep 5
#git pull

grep -r "TODO" * > TODO
wc -l TODO

#work work work
vim

git commit -a -m "automatic commit"
git push
