#!/bin/bash
tmp=$(mktemp)
cat *.csv | while read epoch y
do
	printf '{x: %s, y: %s }\n' "${epoch}000" "$y" >> $tmp
done
while read line; do echo "$line,"; done < $tmp
rm -f $tmp
