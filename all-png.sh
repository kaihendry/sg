#!/bin/bash
t=$(mktemp)
o="${0%-*}.png"

cat << END > $t
set term pngcairo size 1024,768
set output "$o"
set xdata time
set timefmt "%s"
set pointintervalbox 3
plot '-' using 1:2 with linespoints pt 7 lw 2 pi -1 ps 1.5
END

cat *.csv >> $t
cat $t | gnuplot

rm -f $t
