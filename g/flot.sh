#!/bin/bash
# I am symlinked into graph directory, e.g. flot.sh -> ../../bin/g/flot.sh
# Run by https://github.com/kaihendry/sg/blob/master/sg-service


template=$(dirname $(readlink -f $0))/flot
sed -e "s#REPLACE_ME#$($template/csv2d.sh)#" $template/flot.html > flot.html
