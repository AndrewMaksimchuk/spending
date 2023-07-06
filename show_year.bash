#!/usr/bin/env bash


usage='Show all receipts in specified year
Agruments:
  $1 - year(default current)'


projectdir=$(dirname $0)


. $projectdir/get_date_year.bash
. $projectdir/total_by.bash


function get_year() {
    yearfiles=$(find $projectdir/receipts/ -type f -newermt $1-01-01)
    tmp=$(echo $projectdir/tmp/year)
    rm -f $tmp

    for file in $yearfiles
    do
        year=$(get_date_year $file)
        if [[ $year = $1 ]]; then
            echo $file >> $tmp
            cat $file >> $tmp
            echo >> $tmp
        fi
    done

    less $tmp
    total_by $tmp
}


if [[ $1 = "help" ]]; then
    echo "$usage"
    exit
fi


if [[ -z $1 ]]; then
    current_year=$(date +"%Y")
    get_year $current_year
    exit
fi


get_year $1
