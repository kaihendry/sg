#!/bin/bash
template=$(dirname $(readlink -f $0))/morris
cat $template/head.html > morris.html
$template/morris.sh >> morris.html
cat $template/tail.html >> morris.html
