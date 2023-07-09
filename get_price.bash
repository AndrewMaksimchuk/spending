#!/usr/bin/env bash


projectdir=$(dirname $0)


function get_price() {
    file=$(echo "$projectdir/receipts/$1")


    if [[ -e $file ]]; then
        sed -n '3p' $file
    fi

}
