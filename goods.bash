#!/usr/bin/env bash


projectdir=$(realpath `dirname $0`)
receipts="$projectdir/receipts/*"
with_goods=$(grep -l -e "=" $receipts)
list_goods=$(for line in $with_goods
do
    tail -n +5 $line
done)

echo "$list_goods" | sort
