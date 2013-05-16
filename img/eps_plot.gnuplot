#!/usr/bin/gnuplot

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "cauchy.eps"

set log xy
plot for [fn in system("ls data/*")] fn every ::0::1000 using 1:3 with lines title system("basename ".fn)

system("epstopdf cauchy.eps --outfile cauchy.pdf")

reset

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "quot.eps"

set log xy
plot for [fn in system("ls data/*")] fn every ::0::1000 using 1:4 with lines title system("basename ".fn)

system("epstopdf quot.eps --outfile quot.pdf")

reset

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "koeff.eps"

set log xy
plot for [fn in system("ls data/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)

system("epstopdf koeff.eps --outfile koeff.pdf")
