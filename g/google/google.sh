#!/bin/bash
cat *.csv | while read epoch val
do
	test "$val" || continue
	test "$epoch" -gt 100000 || continue
	printf 'data.addRow([new Date(%s), %s]);\n' "${epoch}000" "$val"
done
