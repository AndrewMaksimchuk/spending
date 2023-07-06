#!/usr/bin/env bash


function get_date_time() {
    if [[ -e $1 ]]; then
        sed -n '2p' $1
    fi
}
