#!/bin/bash
# I am symlinked from sg's plotter directory

t=$(mktemp)
o="$WWWDIR/${0%.sh*}.png"

cat << END > $t
set term pngcairo size 1024,768
set output "$o"
set xdata time
set timefmt "%s"
set title "Drawn by the Gnuplot grapher of Suckless Graphs https://github.com/kaihendry/sg/"
set pointintervalbox 3
plot '-' using 1:2 with linespoints pt 7 lw 2 pi -1 ps 1.5
END

cat *.csv | while read epoch val _
do

	# Make sure it's later than 3/3/1973
	test "$epoch" -gt 100000000 || continue
	test "$val" || continue

	test "$val" -eq "$val" 2>/dev/null || continue

	echo "$epoch" "$val"
done >> $t

cat $t | gnuplot
rm -f $t
