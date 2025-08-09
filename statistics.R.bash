#!/usr/bin/env bash


LC_NUMERIC=en_US.UTF-8 # for correct work with numbers in awk
projectdir=$(realpath "$(dirname "$0")")
tmp_table="$projectdir/tmp/table"
all_receipts=$(cd "$projectdir/receipts" || exit; ls -1 | xargs realpath)


printf "%-30s\t%-10.10s\t%-8.8s\t%s\n" "shop" "date" "time" "price" > "$tmp_table"


for receipt in $all_receipts
do
    # shellcheck disable=SC2016
    args='NR==1 {SHOP=$0}; NR==2 {DATE=$1; TIME=$2}; NR==3 {PRICE=$0}; END {printf "%-30s\t%-10.10s\t%-8.8s\t%.2f\n", SHOP, DATE, TIME, PRICE}'
    awk "$args" "$receipt" >> "$tmp_table"
done


cd "$projectdir" && R --no-save --quiet -s -f "$projectdir/statistics.R"
