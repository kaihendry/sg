#!/bin/bash

np=$(mktemp -u)
mkfifo $np
inotifywait -r -m -e CLOSE_WRITE /var/stats > $np & ipid=$!

trap "kill $ipid; rm -f $np" EXIT

while read dir event filename
do
	if test "${filename##*.}" != "csv"; then continue; fi
	cd $dir
	for i in *.sh
	do
		sh "$i"
		echo Triggered: ${dir}${i}
	done
done < $np
