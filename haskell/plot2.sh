#!/bin/sh
  
BASEDIR=$(dirname $0)
max=1000
if [ $# -gt 0 ]; then
  max=$1
fi
plotdir="${BASEDIR}/plot2/"
mkdir -p "${plotdir}"
art[2]="betrag"; art[3]="cauchy"; art[4]="quot";
exc[2]="| grep -v 1000"; exc[3]=""; exc[4]="| grep -v 10000";
for i in 2 3 4; do
  name="${art[i]}"
  echo $name
  gnuplot << EOF
set samples 1001
set key below

set term push
set term post enh color lw 1 12 "Times-Roman"
set output "${BASEDIR}/${name}.eps"

set log xy
plot for [fn in system("ls ${BASEDIR}/data/*${exc[i]}")] fn every ::0::${max}\
  using 1:${i} with lines title system("basename ".fn)
  #linecolor rgb "red"
EOF
  epstopdf "${BASEDIR}/${name}.eps" --outfile "${plotdir}${name}.pdf"
  rm "${BASEDIR}/${name}.eps"
done
