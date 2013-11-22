#!/bin/bash
# I am symlinked into graph directory, e.g. morris.sh -> ../../bin/g/morris.sh
# Run by https://github.com/kaihendry/sg/blob/master/sg-service

template=$(dirname $(readlink -f $0))/morris
cat $template/head.html > morris.html
$template/morris.sh >> morris.html
cat $template/tail.html >> morris.html
