#!/bin/bash
# I am symlinked from sg's plotter directory

days=$(echo $(basename $0 .sh) | cut -d"-" -f2)
if test "$days" -gt 0 2>/dev/null
then

template=$(dirname $(readlink -f $0))/google
echo $template/google.sh $days
cat $template/head.html > $WWWDIR/google-$days.html
$template/google.sh $days >> $WWWDIR/google-$days.html
cat $template/tail.html >> $WWWDIR/google-$days.html

else

template=$(dirname $(readlink -f $0))/google
cat $template/head.html > $WWWDIR/google.html
$template/google.sh >> $WWWDIR/google.html
cat $template/tail.html >> $WWWDIR/google.html

fi
