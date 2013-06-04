#!/bin/bash
if [ -L $0 ] ; then
  DIR=$(dirname $(readlink -f $0)) ;
else
  DIR=$(dirname $0) ;
fi

if [[ ! -n "$TMUX" ]] ; then
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

  grep --exclude='TODO' "TODO" * > TODO
  wc -l TODO
  echo

  #makeindex main.nlo -s nomencl.ist -o main.nls

  tmux new-session -d -s texBa
  tmux new-window -t texBa:2 -n 'latexmk' 'cd main; latexmk -pvc -pdf main.tex'
  #tmux new-window -t texBa:3 -n 'log' 'vim main.log'
  #tmux new-window -t texBa:4 -n 'err' 'watch grep "[Ee]rror" -B3 -A 3 *.log'
  tmux select-window -t texBa:1
  tmux attach-session -t texBa

  git add .
  git commit -a
  git push
else
  cd $DIR

  if [ $# -eq 0 ]; then
    DIALOG=${DIALOG=dialog}
    tempfile=`tempfile 2>/dev/null` || tempfile=/tmp/mymenudialog$$
    trap "rm -f $tempfile" 0 1 2 5 15

    $DIALOG --title "menu" \
      --menu "Please choose:" 15 55 5 \
      1 "commit" \
      2 "zathura" \
      3 "latexmk" \
      4 "dropbox" 2> $tempfile

    retval=$?
    [ $retval -eq 1 -o $retval -eq 255 ] && exit
    choice=$(cat $tempfile)
  else
    choice=$1
  fi


  case $choice in
    1) #commit
      grep -r --exclude='TODO' "TODO" * > TODO
      wc -l TODO
      git commit -a
      git push
      ;;
    2) while true; do zathura -l error main.pdf; sleep 1; done
      ;;
    3) latexmk -pvc -pdf main.tex
      ;;
    4) DropboxON=$(ps -A | grep -c dropbox)
      if [[ $DropboxON == "0" ]]; then
        echo "dropbox started, pid:"
        dropboxd &
        echo $!
      else
        echo "dropbox is already running"
      fi
      ;;
  esac
fi
