#!/bin/bash
cat *.csv | while read epoch y
do
	printf '{x: %s, y: %s },\n' "${epoch}000" "$y"
done
