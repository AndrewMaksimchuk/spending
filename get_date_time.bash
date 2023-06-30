#!/usr/bin/env bash


. projectdir.bash



function get_date_time() {
    file=$(echo "$projectdir/receipts/$1")


    if [[ -e $file ]]; then
        sed -n '2p' $file
    fi

}
