#!/usr/bin/env bash


# If run this script without argument it show by 
# default total cost of all exits receipts.
# 
# If you want count specific list of receipts 
# put list of receipts like argument to this script.
# Example: ./total.bash "file1 file2 file3"
# App command: spending total "file1 file2 file3"


cwd=$(dirname $0)


. $cwd/list.bash


tmp=$(echo $projectdir/tmp/total)


function total() {
    rm -f $tmp
    for file in $1
    do
        filepath=$(echo "$projectdir/receipts/$file")
        if [[ -e $filepath ]]; then
            cost=$(sed -n '3p' $filepath)
            echo $cost >> $tmp
        fi
    done

    receipts_counter=$(echo $1 | wc -w)
    echo "Receipts: $receipts_counter"
    total_counter=$(cat $tmp | awk '{s+=$1}END{printf "%.2f\n", s}')
    echo "Total value: $total_counter"
}


if [ $# -eq 0 ]
  then
    total "$receipts_files"
    exit
fi


total "$1"
