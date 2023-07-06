#!/usr/bin/env bash


[[ -z $1 ]] && return


projectdir=$(dirname $0)


file=$(echo "$projectdir/receipts/$1")


if [[ -e $file ]]; then
    echo $file
    cat $file
fi
