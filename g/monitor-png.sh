#!/bin/bash
o="${0%-*}.png"
t=$(mktemp)
cat *.csv > $t

cat << END | gnuplot
set terminal png size 800,200
set output "$o"
set yrange[-0.5:1.5]
set clip two
set ytics (0,1)
set xdata time
set xtics 9676800
set timefmt "%s"
plot '$t' using 1:2 title "ICMP" with lines,     '$t' using 1:3 title "HTTP" with lines,     '$t' using 1:4 title "DNS" with lines,     '$t' using 1:5 title "SMTP" with lines
END
