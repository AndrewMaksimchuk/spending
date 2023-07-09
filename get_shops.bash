#!/usr/bin/env bash


projectdir=$(dirname $0)


. $projectdir/get_shop.bash


function prints() {
    tmp=$(echo $projectdir/tmp/shops)

    rm -f $tmp

    for file in $1
    do
        name=$(basename $file)
        shop=$(get_shop $name)
        echo $(echo $shop | tr " " "_")
        echo >> $tmp
        echo $(readlink -f $file) >> $tmp
        echo $shop >> $tmp
    done
}


function get_shops() {
    files=$(echo $projectdir/receipts/*)
    tmp=$(echo $projectdir/tmp/shop_list)
    
    rm -f $tmp
    prints "$files" | sort | uniq | tee $tmp
}
