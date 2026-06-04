#!/usr/bin/env bash


# Get date from receipt file
#
# Arguments:
#   $1 - path to receipt file 


projectdir=$(dirname "$0")

. "$projectdir/get_date_time.bash"


function get_date() {
    if [[ ! -e $1 ]]; then 
        echo "$1 this receipt file not exist"
        exit 0
    fi
    
    date_time=$(get_date_time "$1")

    if [[ -n $date_time ]]; then
        echo "$date_time" | awk '{print $1}'
    else
        echo "24.02.2022"
    fi
}
