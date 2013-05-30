#!/bin/sh
max=1000
plotdir="./plot/"
if [ $# -gt 0 ]; then
  max=$1
  if [ $# -gt 1 ]; then
    if [ "$2" == "final" ]; then
      plotdir="../img/"
    fi
  fi
fi

if true; then
  ghc --make -threaded ./Main.hs
  mkdir -p ./data
  rm ./data/u_*
  ./Main $max +RTS -N3
fi

if true; then
  mkdir -p ./plot
  art[2]="betrag"; art[3]="cauchy"; art[4]="quot";
  for i in 2 3 4; do
    name="${art[i]}"
    echo $name
    gnuplot << EOF
set samples 1001
set key below

set term push
set term post enh color lw 1 12 "Times-Roman"
set output "${name}.eps"

set log xy
plot for [fn in system("ls data/*")] fn every ::0::${max} using 1:${i} with lines title system("basename ".fn)
EOF
    epstopdf "${name}.eps" --outfile "${plotdir}${name}.pdf"
    rm "${name}.eps"
  done
fi
