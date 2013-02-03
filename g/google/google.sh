#!/bin/bash
cat *.csv | while read epoch y
do
	printf '[new Date(%s), %s],\n' "${epoch}000" "$y"
done
