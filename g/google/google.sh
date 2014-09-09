#!/bin/bash

if test "$1" -gt 0 2>/dev/null
then
	top=$1
else
	# get all
	top="-0"
fi

f=$(( $(awk 'NR==1 { print NF }' $(ls -t *.csv | head -n1)) - 1))
echo Fields: $f 1>&2

echo '["Date", "", ""],'

cat $(ls -t *.csv | head -n$top) | while read -a fields
do
	# Make sure we have a reading
	test "${fields[1]}" || continue
	# Make sure it's later than 3/3/1973
	test "${fields[0]}" -gt 100000000 || continue
	echo -n "[new Date(${fields[0]}000)"
	for i in $(seq 1 $f)
	do
		val=${fields[$i]}
		if test "$val"
		then
			echo -n ", $val"
		else
			echo -n ", null"
		fi
	done
	echo "],"
done
