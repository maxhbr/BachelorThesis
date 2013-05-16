#!/bin/sh
max=10000
art[2]="betrag"; art[3]="cauchy"; art[4]="quot"; art[5]="fac"

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
  epstopdf "${name}.eps" --outfile "${name}.pdf"
done
