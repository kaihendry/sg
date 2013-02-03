#!/bin/bash
template=$(dirname $(readlink -f $0))/google
cat $template/head.html > google.html
$template/google.sh >> google.html
cat $template/tail.html >> google.html
