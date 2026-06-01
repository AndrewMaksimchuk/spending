#!/usr/bin/env bash


projectdir=$(dirname "$0")


# Arguments:
#   $1 - receipt file name(not a path), for example: 0a2edf1d-c981-4cfc-b70a-be97bc674b5c
function get_price() {
    file="$projectdir/receipts/$1"

    if [[ -e $file ]]; then
        sed -n '3p' "$file"
    fi
}
