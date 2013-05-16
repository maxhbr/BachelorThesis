#!/usr/bin/gnuplot  
reset

#Koordinatenkreuz und andere Einstellungen
#set zeroaxis
#set samples 500
set key below
#set lmargin screen 0.07

set angles radians
set grid polar pi/6.

unset border        
unset tics 
#set label 1 "1" at 1, -10
#set label 10 "10" at 2.3, -10
#set label 100 "100" at 4.6, -10
#set label 1000 "1000" at 6.9, -10
set label 115.12925464970229 "1.0e50" at 115.12925464970229, -40
set label 230.25850929940458 "1.0e100" at 230.25850929940458, -40
set label 345.38776394910684 "1.0e150" at 345.38776394910684, -40
set label 460.51701859880916 "1.0e200" at 460.51701859880916, -40
set label 575.6462732485114 "1.0e250" at 575.6462732485114, -40


#set size 0.7,1.4; 
set term push
#set term post portrait color "Times-Roman" 14
set term post enh color lw 1 12 
set output "spiral.eps"


#set logscale xy
set polar
plot for [fn in system("ls spiral/*")] fn every ::0::1000 using 1:2 with lines title system("basename ".fn)


replot

system("epstopdf spiral.eps --outfile ../../img/spiral.pdf")
