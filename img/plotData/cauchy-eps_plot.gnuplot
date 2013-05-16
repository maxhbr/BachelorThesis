#!/usr/bin/gnuplot

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "cauchy.eps"

set log y
set log x
plot for [fn in system("ls cauchy/*")] fn every ::0::1000 using 1:3 with lines title system("basename ".fn)

system("epstopdf cauchy.eps --outfile ../../img/cauchy.pdf")
