#!/bin/bash

if test "$1" -gt 0 2>/dev/null
then
	top=$1
else
	# get all
	top="-0"
fi

echo "data.addColumn('datetime', 'Date');"

f=$(( $(awk 'NR==1 { print NF }' $(ls -t *.csv | head -n1)) - 1))

for ((i=1; i<=f; i++))
do
	cat ${i}.header
done

cat $(ls -t *.csv | head -n$top) | while read -a fields
do
	# Make sure it's later than 3/3/1973
	test "${fields[0]}" -gt 100000000 || continue

	# Make sure we have all the values
	test ${#fields[@]} -eq $f && continue

	printf 'data.addRow([new Date(%s), %s' "${fields[0]}000" "${fields[1]}"
	for ((i=2; i<=f; i++))
	do
		val=${fields[$i]}
		if test "$val"
		then
			echo -n ", \"$val\""
		else
			echo -n ", null"
		fi
	done
	echo "]);"
done
