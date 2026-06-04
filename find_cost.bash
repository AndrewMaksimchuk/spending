#!/usr/bin/env bash


. list.bash
. get_price.bash


tmp="$projectdir/tmp/find_cost"
rm -f "$tmp"


for file in $receipts_files
do
    current_price=$(get_price "$file")
    echo "$current_price $file" >> "$tmp"
done


[[ ! -e $tmp ]] && exit


finded=$(grep -F "$1" "$tmp")


if [[ -n $finded ]]; then
    filename=$(awk '{print $2}' <<< "$finded")
    echo "$filename"
    cat "$projectdir/receipts/$filename"
fi
