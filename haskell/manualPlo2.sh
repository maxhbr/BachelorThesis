#!/bin/sh
  
cd $(dirname $0)
max=10000
if [ $# -gt 0 ]; then
  max=$1
fi
plotdir="plot2/"
mkdir -p "${plotdir}"
art[2]="betrag"; art[3]="cauchy"; art[4]="quot";
for i in 2 3 4; do
  name="${art[i]}"
  echo $name
  if [ "$i" -eq "2" ]; then
    gnuplot << EOF
set samples 1001
set key below

set term push
set term post enh color lw 1 12 "Times-Roman"
set output "${name}.eps"

set log xy
plot "data2/u_-2=1.0e-5i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i10^{-5}i",\
  "data2/u_-2=1.0e-4i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i10^{-4}",\
  "data2/u_-2=1.0e-3i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i10^{-3}",\
  "data2/u_-2=1.0e-2i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i10^{-2}",\
  "data2/u_-2=1.0e-1i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i10^{-1}",\
  "data2/u_-2=i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=i" lc rgb "orange",\
  "data2/u_-2=10i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=10i",\
  "data2/u_-2=100i" every ::0::1000 using 1:${i} with lines\
  title "u_{-2}=100i"
EOF
  else
    gnuplot << EOF
set samples 1001
set key below

set term push
set term post enh color lw 1 12 "Times-Roman"
set output "${name}.eps"

set log xy
plot "data2/u_-2=1.0e-5i" using 1:${i} with lines\
  title "u_{-2}=i10^{-5}i",\
  "data2/u_-2=1.0e-4i" using 1:${i} with lines\
  title "u_{-2}=i10^{-4}",\
  "data2/u_-2=1.0e-3i" using 1:${i} with lines\
  title "u_{-2}=i10^{-3}",\
  "data2/u_-2=1.0e-2i" using 1:${i} with lines\
  title "u_{-2}=i10^{-2}",\
  "data2/u_-2=1.0e-1i" using 1:${i} with lines\
  title "u_{-2}=i10^{-1}",\
  "data2/u_-2=i" using 1:${i} with lines\
  title "u_{-2}=i" lc rgb "orange",\
  "data2/u_-2=10i" using 1:${i} with lines\
  title "u_{-2}=10i",\
  "data2/u_-2=100i" using 1:${i} with lines\
  title "u_{-2}=100i",\
  "data2/u_-2=1000i" using 1:${i} with lines\
  title "u_{-2}=1000i",\
  "data2/u_-2=10000i" using 1:${i} with lines\
  title "u_{-2}=10000i" lc rgb "violet"
EOF
#TODO: nehme quot werte aus alter berechnung?
  fi
  epstopdf "${name}.eps" --outfile "${plotdir}${name}.pdf"
  rm "${name}.eps"
done
