#!/usr/bin/gnuplot

#Koordinatenkreuz und andere Einstellungen
#set zeroaxis
#set samples 500
set key below
#set lmargin screen 0.07

#set size 0.7,1.4; 
set term push
#set term post portrait color "Times-Roman" 14
set term post enh color lw 1 12 
set output "koeff.eps"

set log y
set log x
plot for [fn in system("ls n=1000/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)

system("epstopdf koeff.eps --outfile ../../img/koeff.pdf")
