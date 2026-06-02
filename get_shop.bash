#!/usr/bin/env bash


# Get name of shop
# Arguments:
#   $1 - file name(without path)


projectdir=$(dirname "$0")


function get_shop() {
    [[ -z $1 ]] && echo "Argument not provided" && exit

    file="$projectdir/receipts/$1"
    [[ ! -e $file ]] && echo "$1 not exist" && exit

    shop=$(sed -n '1p' "$file")
    echo "\"$shop\""
}
