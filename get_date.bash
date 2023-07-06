#!/usr/bin/env bash


projectdir=$(dirname $0)


. $projectdir/get_date_time.bash


function get_date() {
    [[ ! -e $1 ]] && exit
    
    date_time=$(get_date_time $1)

    if [[ -n $date_time ]]; then
        echo $date_time | awk '{print $1}'
    fi
}
