#!/bin/bash
# https://github.com/kaihendry/sg/

# echo $(cat /sys/class/thermal/thermal_zone0/temp) $(uname -r) | ~/bin/sg/sg-client -d sg -g temp

# Expects data in the format:

# 1360641001 56000 3.0.62-1-lts
# 1360641301 76000 3.7.6-1-ARCH

lastcsv=$(ls -t *.csv | head -n1)
o="$(basename $lastcsv .csv).png"

cat << END | gnuplot
set term pngcairo size 1366,768
set output "$o"
set title "Suckless Graphs Laptop temperature"
set xdata time
set ylabel "Temperature (C)"
set xlabel "Time"
set timefmt "%H%M"
set grid
set key outside
set timefmt "%s"
set ytics 2
archs = "`cut -d' ' -f3 $lastcsv | sort -u | tr '\n' ' '`"
plot for [arch in archs] '$lastcsv' using 1:((strcol(3) eq arch) ? (\$2/1000):1/0) title arch with linespoints
END

# Clean up if we have a dud
test -s $o || rm $o
ln -sf $o latest.png
