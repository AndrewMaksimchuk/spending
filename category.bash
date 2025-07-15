#!/usr/bin/env bash

# $1 - subcommands "add"
# $2 - argument for $1 subcommands


projectdir=$(dirname $0)
file_category="$projectdir/category_list"


if [[ "$1" = "add" ]]; then

    if [[ -z "$2" ]]; then
        exit
    fi

    echo "$2" >> $file_category
    exit
fi

cat $file_category
