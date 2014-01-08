#!/bin/bash

if test "$1" -gt 0 2>/dev/null
then

cat $(ls -t *.csv | head -n$1) | while read epoch val
do
	test "$val" || continue
	test "$epoch" -gt 100000 || continue
	printf 'data.addRow([new Date(%s), %s]);\n' "${epoch}000" "$val"
done

else

cat *.csv | while read epoch val
do
	test "$val" || continue
	test "$epoch" -gt 100000 || continue
	printf 'data.addRow([new Date(%s), %s]);\n' "${epoch}000" "$val"
done

fi
