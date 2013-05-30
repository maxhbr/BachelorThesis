#!/bin/sh
max=$1
if [ "$#" == "2" ]; then
  path=$2
else
  path="data"
fi
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
plot for [fn in system("ls ${path}/*")] fn every ::0::${max} using 1:${i} with lines title system("basename ".fn)
EOF
  epstopdf "${name}.eps" --outfile "${name}.pdf"
  #rm "${name}.eps"
done
