#!/bin/bash
# I am symlinked into graph directory, e.g. all-png.sh -> ../../bin/g/all-png.sh
# Run by https://github.com/kaihendry/sg/blob/master/sg-service

t=$(mktemp)
o="${0%-*}.png"

cat << END > $t
set term pngcairo size 1024,768
set output "$o"
set xdata time
set timefmt "%s"
set title "Drawn by the Gnuplot grapher of Suckless Graphs https://github.com/kaihendry/sg/"
set pointintervalbox 3
plot '-' using 1:2 with linespoints pt 7 lw 2 pi -1 ps 1.5
END

cat *.csv >> $t
cat $t | gnuplot

rm -f $t
