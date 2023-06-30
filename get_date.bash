#!/usr/bin/env bash


function get_date() {
    date_time=$1

    if [[ -n $date_time ]]; then
        echo $date_time | awk '{print $1}'
    fi
}
