#!/usr/bin/env bash


usage='Show all receipts in specified month
Arguments:
  $1 - month(default current)
  $2 - year(default current)'


projectdir=$(dirname $0)


. $projectdir/get_date_month.bash
. $projectdir/total_by.bash


function get_month() {
    if [[ -z $2 ]]; then
        current_year=$(date +"%Y")
    else
        current_year=$2
    fi
    
    month_files=$(find $projectdir/receipts/ -type f -newermt $current_year-$1-01)
    tmp=$(echo $projectdir/tmp/month)
    rm -f $tmp

    for file in $month_files
    do
        month=$(get_date_month $file)
        if [[ $month = $1 ]]; then
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
    current_month=$(date +"%m")
    get_month $current_month $2
    exit
fi


get_month $1 $2
