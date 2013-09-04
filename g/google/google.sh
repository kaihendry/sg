#!/bin/bash
cat *.csv | while read epoch y
do
	printf 'data.addRow([new Date(%s), %s]);\n' "${epoch}000" "$y"
done
