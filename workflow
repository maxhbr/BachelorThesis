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


tmux new-session -d -s tex
tmux new-window -t tex:2 -n 'latexmk' 'latexmk -pvc -pdf main.tex'
tmux new-window -t tex:3 -n 'log' 'vim main.log'
tmux new-window -t tex:4 -n 'watch grep "[Ee]rror" -B3 -A 3 *.log'
tmux select-window -t tex:1
tmux attach-session -t tex

git commit -a -m "automatic commit"
git push
