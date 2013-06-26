#!/bin/sh
max=1000
plotdir="./plot/"
if [ $# -gt 0 ]; then
  max=$1
fi

ghc --make -threaded ./SaveToFile2.hs
mkdir -p ./data2
rm ./data2/u_*
./SaveToFile2 $max +RTS -N3
