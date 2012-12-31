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

#makeindex main.nlo -s nomencl.ist -o main.nls

tmux new-session -d -s texBa
tmux new-window -t texBa:2 -n 'latexmk' 'latexmk -pvc -pdf main.tex'
tmux new-window -t texBa:3 -n 'log' 'vim main.log'
tmux new-window -t texBa:4 -n 'err' 'watch grep "[Ee]rror" -B3 -A 3 *.log'
tmux select-window -t texBa:1
tmux attach-session -t texBa

git add .
git commit -a
git push
