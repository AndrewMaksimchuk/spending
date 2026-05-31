#!/usr/bin/env bash


# Get date and time line from receipt file
#
# Arguments:
#   $1 - path to receipt file 


function get_date_time() {
    if [[ -e $1 ]]; then
        sed -n '2p' "$1"
    fi
}
