#!/usr/bin/env bash


# Show all receipts from selected shop
# Arguments:
#   $1 - "help" option


projectdir=$(dirname $0)


. $projectdir/get_shops.bash
. $projectdir/print.bash
. $projectdir/total_by.bash


function show_shops() {
    shops=$(get_shops)
    quite="exit"
    PS3="Select shop(enter number): "

    select shop in $quite $shops
    do
        [[ $shop = $quite ]] && exit
        [[ -z $shop ]] && exit

        search_word=$(echo $shop | tr "_" " ")
        file_names=$(cat $projectdir/tmp/shops \
        | grep -B 1 "$search_word" \
        | grep "^/")

        tmp=$(echo $projectdir/tmp/shop)
        rm -f $tmp

        for file in $file_names
        do
            echo $file >> $tmp
            cat $file >> $tmp
            echo >> $tmp
        done

        less $tmp
        total_by $tmp
        exit
    done
}


show_shops
