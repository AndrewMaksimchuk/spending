#!/usr/bin/env bash


projectdir=$(realpath "$(dirname "$0")")
receipts="$projectdir/receipts/*"

list_goods=$(for line in $receipts; do
    awk '/^=$/{c++; next} c==1' "$line"
done)

echo "$list_goods" | sort
