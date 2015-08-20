#!/bin/bash

if test "$1" -gt 0 2>/dev/null
then
	top=$1
else
	top="-0" # get all
fi

cat <<END
data.addColumn('datetime', 'Date');
data.addColumn('number', 'value');
END

cat $(ls -t *.csv | head -n$top) | while read -a fields
do

	test "${fields[0]}" -gt 100000000 || continue # Make sure it's later than 3/3/1973

	printf "data.addRow([new Date(%d), %d]);\n" "${fields[0]}000" "${fields[1]}"
done
