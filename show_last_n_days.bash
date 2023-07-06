#!/usr/bin/env bash


# Show last added receipts n days ago


projectdir=$(dirname $0)


. $projectdir/get_date.bash
. $projectdir/total_by.bash


last_days=$(find $projectdir/receipts/ -type f -ctime -$1)
tmp=$(echo $projectdir/tmp/last_days)
rm -f $tmp


function prints() {
    for file in $last_days
    do
        date=$(get_date $file)
        echo "$date $file"

        echo $(readlink -f $file) >> $tmp
        cat $file >> $tmp
        echo >> $tmp
    done
}

prints | sort
total_by $tmp

less $tmp
