#!/usr/bin/env bash


. projectdir.bash


last7days=$(find $projectdir/receipts/ -type f -ctime -7)
tmp=$(echo $projectdir/tmp/last7days)
rm -f $tmp


for day in $last7days
do
    echo $day >> $tmp
    cat $day >> $tmp
    echo >> $tmp
done


less $tmp
