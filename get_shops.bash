#!/usr/bin/env bash


projectdir=$(dirname "$0")


. "$projectdir/get_shop.bash"


function prints() {
    local tmp="$projectdir/tmp/shops"

    rm -f "$tmp"

    for file in $1
    do
        name=$(basename "$file")
        shop=$(get_shop "$name") # function get_shop return shop name in double quotes
        echo "$shop" | tr " " "_"
        {
            echo
            readlink -f "$file"
            echo "$shop"
        } >> "$tmp"
    done
}


function get_shops() {
    local tmp="$projectdir/tmp/shop_list"

    if [[ -e $tmp ]]; then
        cat "$tmp"
        exit
    fi

    local files="$projectdir/receipts/*"
    prints "$files" | sort | uniq | tee "$tmp"
}
