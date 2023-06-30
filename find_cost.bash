#!/usr/bin/env bash


. list.bash
. get_price.bash


tmp=$(echo $projectdir/tmp/find_cost)
rm -f $tmp


price=0


for file in $receipts_files
do
    current_price=$(get_price $file)
    echo "$current_price $file" >> $tmp
done


[[ ! -e $tmp ]] && exit


finded=$(cat $tmp | grep $1)


if [[ -n $finded ]]; then
    filename=$(echo $finded | awk '{print $2}')
    echo $filename
    cat $projectdir/receipts/$filename
fi
