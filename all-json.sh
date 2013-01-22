#!/bin/bash
# TODO: Bug with trailing comma
echo '['
cat *.csv | while read epoch y
do
	printf '{ "epoch" : "%s", "y" : %s }' "$epoch" "$y"
	echo ,
done
echo ']'
