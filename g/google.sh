#!/bin/bash
# I am symlinked into graph directory, e.g. google.sh -> ../../bin/g/google.sh
# Run by https://github.com/kaihendry/sg/blob/master/sg-service


template=$(dirname $(readlink -f $0))/google
cat $template/head.html > google.html
$template/google.sh >> google.html
cat $template/tail.html >> google.html
