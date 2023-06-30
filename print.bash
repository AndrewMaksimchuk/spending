#!/usr/bin/env bash


. list.bash


file=$(echo "$projectdir/receipts/$1")


if [[ -e $file ]]; then
    echo $file
    cat $file
fi
