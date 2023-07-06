#!/usr/bin/env bash


usage='Show all receipts in specified day
Agruments:
  $1 - day(default current)
  $2 - month(default current)
  $3 - year(default current)'


projectdir=$(dirname $0)


. $projectdir/get_date_day.bash
. $projectdir/total_by.bash


function get_day() {
    if [[ -z $2 ]]; then
        current_month=$(date +"%m")
    else
        current_month=$2
    fi
    
    if [[ -z $3 ]]; then
        current_year=$(date +"%Y")
    else
        current_year=$3
    fi

    day_files=$(find $projectdir/receipts/ -type f -newermt $current_year-$current_month-$1)
    tmp=$(echo $projectdir/tmp/day)
    rm -f $tmp

    for file in $day_files
    do
        day=$(get_date_day $file)
        if [[ $day = $1 ]]; then
            echo $file >> $tmp
            cat $file >> $tmp
            echo >> $tmp
        fi
    done

    if [[ ! -e $tmp ]]; then
        echo "You not have receipts"
        exit
    fi

    less $tmp
    total_by $tmp
}


if [[ $1 = "help" ]]; then
    echo "$usage"
    exit
fi


if [[ -z $1 ]]; then
    current_day=$(date +"%d")
    get_day $current_day $2 $3
    exit
fi


get_day $1 $2 $3
