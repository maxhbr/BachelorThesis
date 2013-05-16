#!/usr/bin/gnuplot

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "koeff.eps"

set log y
set log x
plot for [fn in system("ls n=1000/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)

system("epstopdf koeff.eps --outfile ../../img/koeff.pdf")

reset

set samples 1001
set key below

set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "koeff-large.eps"

set log y
set log x
plot for [fn in system("ls n=1000/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)

system("epstopdf koeff-large.eps --outfile ../../img/koeff-large.pdf")

reset

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "koeff-logx.eps"

set log y
plot for [fn in system("ls n=1000/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)

system("epstopdf koeff-logx.eps --outfile ../../img/koeff-logx.pdf")
