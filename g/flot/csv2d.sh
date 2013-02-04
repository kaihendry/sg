#!/bin/bash
tmp=$(mktemp)
cat *.csv | while read epoch y
do
	printf '[%s,%s]\n' "${epoch}000" "$y" >> $tmp
done
echo -n '['
cat $tmp | tr '\n' ',' | sed -e 's/,$//'
echo ']'
rm -f $tmp
