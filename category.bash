#!/usr/bin/env bash


# Arguments:
# $1 - subcommands "add"
# $2 - argument for $1 subcommands


projectdir=$(dirname "$0")
file_category="$projectdir/category_list"


if [[ "$1" = "add" ]]; then

    if [[ -z "$2" ]]; then
        echo "Try again but add the name of category"
        exit 0
    fi

    echo "$2" >> "$file_category"
    echo "$2 is added"
    exit 0
fi

cat "$file_category"
