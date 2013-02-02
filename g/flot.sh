#!/bin/bash
template=$(dirname $(readlink -f $0))/flot
sed -e "s#REPLACE_ME#$($template/csv2d.sh)#" $template/flot.html > flot.html
