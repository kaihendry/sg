#!/bin/bash
cat *.csv | while read epoch y _
do
	# Make sure it's later than 3/3/1973
	test "$epoch" -gt 100000000 || continue
	test "$y" || continue
	printf '{x: %s, y: %s },\n' "${epoch}000" "$y"
done
