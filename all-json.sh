#!/bin/bash
o="${0%-*}.json"

tmp=$(mktemp)
cat *.csv | while read epoch y
do
	printf '{ "epoch" : "%s", "y" : %s }\n' "$epoch" "$y" >> $tmp
done
echo -n '[' > $o
cat $tmp | tr '\n' ',' | sed -e 's/,$//' >> $o
echo ']' >> $o

rm -f $tmp
