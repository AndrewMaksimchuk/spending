#!/usr/bin/env bash


projectdir=$(dirname $0)


. $projectdir/get_date.bash


function get_date_day() {
    [[ ! -e $1 ]] && exit
    
    date_time=$(get_date $1)

    if [[ -n $date_time ]]; then
        echo $date_time | awk 'BEGIN { FS = "." } ; {print $1}'
    fi
}
