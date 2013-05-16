#!/usr/bin/gnuplot

set samples 1001
set key below

#set size 0.7,1.4; 
set term push
set term post enh color lw 1 12 "Times-Roman"
set output "quot.eps"

set log xy
plot "data/a=0.125" using 1:4 with lines title system("basename "."data/a=0.125")

system("epstopdf quot.eps --outfile quot.pdf")
