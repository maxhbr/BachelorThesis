#!/bin/sh
max=$1

if false; then
  ghc --make -threaded ./koeff.hs
  mkdir -p ./data
  ./koeff $max +RTS -N3
fi

if true; then
  art[2]="betrag"; art[3]="cauchy"; art[4]="quot";
  for i in 2 3 4; do
    name="${art[i]}"
    gnuplot << EOF
set samples 1001
set key below

set term push
set term post enh color lw 1 12 "Times-Roman"
set output "${name}.eps"

set log xy
plot for [fn in system("ls data/*")] fn every ::0::${max} using 1:${i} with lines title system("basename ".fn)
EOF
    epstopdf "${name}.eps" --outfile "../img/${name}.pdf"
    rm "${name}.eps"
  done
fi
