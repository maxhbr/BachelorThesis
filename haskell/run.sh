#!/bin/sh
max=1000
plotdir="./plot/"
if [ $# -gt 0 ]; then
  max=$1
  #if [ $# -gt 1 ]; then
    #if [ "$2" == "final" ]; then
      #plotdir="../img/"
    #fi
  #fi
fi

if false; then
  ghc --make -threaded ./SaveToFile.hs
  mkdir -p ./data
  rm ./data/u_*
  ./SaveToFile $max +RTS -N3
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
plot for [fn in system("ls data/*")] fn every ::0::${max} using 1:${i}\
  with lines title system("basename ".fn)
EOF
    epstopdf "${name}.eps" --outfile "${plotdir}${name}.pdf"
    rm "${name}.eps"
  done
  #name="cauchy-shaded"
  #echo $name
  #gnuplot << EOF
#set samples 1001
#set key below

#set term push
#set term post enh color lw 1 12 "Times-Roman"
#set output "${name}.eps"

#set yrange [0.00001:1e10]

#set log xy
#plot 10**(ceil(300/x)) with filledcurve y1=10^300 lt rgb "#DDDDDD" title "",\
  #for [fn in system("ls data/*")] fn every ::0::${max} using 1:3\
    #with lines title system("basename ".fn)
##splot [-2:2] [-2:2] f(x,y) t 'x^3 - 2xy + y^3>0'
#EOF
  #epstopdf "${name}.eps" --outfile "${plotdir}${name}.pdf"
  #rm "${name}.eps"
fi
