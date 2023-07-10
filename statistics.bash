#!/usr/bin/env bash


projectdir=$(dirname $0)
tmp=$(echo $projectdir/tmp/statistics)


rm -f $tmp


. $projectdir/get_shops.bash
. $projectdir/get_price.bash


function mean
{
    # $1 - list of prices or empty string
    [[ -z $1 ]] && echo "Mean: 0" && return

    n=$(echo $1 | wc -w)
    total_counter=$(echo "$1" | awk '{s+=$1}END{printf "%.2f\n", s}')
    mean_value=$(bc <<< "scale=2; $total_counter / $n")
    echo "Mean: $mean_value"
}


function median
{
    # $1 - list of prices or empty string
    [[ -z $1 ]] && echo "Median: 0" && return

    n=$(echo $1 | wc -w)

    if [[ $(( $n & 1 )) -eq 0 ]]; then
        middle_left=$(bc <<< "($n + 1) / 2")
        middle_right=$(bc <<< "$middle_left + 1")
        middle_value_left=$(echo $1 | awk -v middle=$middle_left '{print $middle}')
        middle_value_right=$(echo $1 | awk -v middle=$middle_right '{print $middle}')
        middle_value=$(bc <<< "scale=2; ($middle_value_left + $middle_value_right) / 2")
        echo "Median: $middle_value"
        return
    fi

    middle=$(bc <<< "($n + 1) / 2")
    middle_value=$(echo $1 | awk -v middle=$middle '{print $middle}')
    echo "Median: $middle_value"
}


function range
{
    # $1 - list of prices or empty string
    [[ -z $1 ]] && echo "Range: 0" && return

    smallest=$(echo "$1" | head -1)
    largest=$(echo "$1" | tail -1)
    range=$(bc <<< "scale=2; $largest - $smallest")
    echo "Range: $range"
}


function mean_median_range
{
    current_month=$(date +"%m")
    list_month=$(seq -w $current_month)
    local tmp=$(echo $projectdir/tmp/mean_median_range)

    rm -f $tmp

    for month in $list_month
    do
        month_data=$($projectdir/show_month.bash $month)
        echo "Month: $month" >> $tmp
        
        if [[ ${#month_data} -eq 0 ]]; then
            mean "" >> $tmp
            median "" >> $tmp
            range "" >> $tmp
            echo >> $tmp
            continue
        fi

        prices=$(cat "$projectdir/tmp/month" \
        | grep "^[0-9]*.[0-9][0-9]$" \
        | sort -n)

        mean "$prices" >> $tmp
        median "$prices" >> $tmp
        range "$prices" >> $tmp
        echo >> $tmp
    done

    cat $tmp
}


function frequency_tables
{
    # of shops
    # for all time(all receipts)
    shops=$(get_shops)
    receipts=$(echo $projectdir/receipts/*)
    tmp_frequency_tables=$(echo $projectdir/tmp/frequency_tables)
    rm -f $tmp_frequency_tables

    for shop in $shops
    do
        [[ ${#shop} -le 2 ]] && continue
        
        search_word=$(echo $shop | tr "_" " ")
        search_word=$(echo "${search_word:1:${#search_word}-2}")
        couter=$(grep "$search_word" -r $projectdir/receipts | wc -l)
        echo "$shop $couter" >> $tmp_frequency_tables
    done

    column -t -N 'shop,receipts' $tmp_frequency_tables
}


function relative_frequency_table
{
    # of shops
    # for all time(all receipts)
    frequency_tables_file=$(cat $projectdir/tmp/frequency_tables)
    
    total=$(echo "$frequency_tables_file" \
    | cut -d " " -f 2 \
    | awk '{s+=$1}END{printf "%d\n", s}')
    
    shops_list=$(echo "$frequency_tables_file" \
    | cut -d " " -f 1)
    
    tmp_relative_frequency_tables=$(echo $projectdir/tmp/relative_frequency_tables)
    rm -f $tmp_relative_frequency_tables

    for shop in $shops_list
    do
        counter=$(echo "$frequency_tables_file" | grep $shop | cut -d " " -f 2)
        value=$(bc <<< "scale=2; ($counter * 100) / $total")
        echo "$shop $value%" >> $tmp_relative_frequency_tables
    done

    column -t -N 'shop,receipts' $tmp_relative_frequency_tables
}


function cumulative_frequency_tables
{
    local receipts=$(ls $projectdir/receipts/)
    local tmp_prices=$(echo $projectdir/tmp/prices)
    tmp_cumulative_frequency_tables=$(echo $projectdir/tmp/cumulative_frequency_tables)

    rm -f $tmp_prices
    rm -f $tmp_cumulative_frequency_tables
    
    for file in $receipts
    do
        get_price $file >> $tmp_prices
    done

    local tmp_prices_sorted=$(cat "$tmp_prices" | sort -n)
    couter=0

    for value in {100..1000..100}
    do
        for price in $tmp_prices_sorted
        do
            bool=$(bc <<< "scale=2; $price <= $value")
            [[ $bool -eq 0 ]] && break
            ((++counter))
        done
        echo "$value $counter" >> $tmp_cumulative_frequency_tables
        counter=0
    done

    for value in {2000..10000..1000}
    do
        for price in $tmp_prices_sorted
        do
            bool=$(bc <<< "scale=2; $price <= $value")
            [[ $bool -eq 0 ]] && break
            ((++counter))
        done
        echo "$value $counter" >> $tmp_cumulative_frequency_tables
        counter=0
    done

    column -t -N 'cost,receipts' $tmp_cumulative_frequency_tables
}


function put_empty_line
{
    echo >> $tmp
}


function print_dashboard
{
    local data_mean_median_range=$(pr -ats" " --columns 5 $projectdir/tmp/mean_median_range)
    local headers_mean_median_range=$(echo "$data_mean_median_range" | awk '{print $1, $3, $5, $7}' | head -1 | tr ":" "," | tr -d " ")
    local board_mean_median_range=$(echo "$data_mean_median_range" | awk '{print $2, $4, $6, $8}' | column -t -N "$headers_mean_median_range")

    echo
    echo "$board_mean_median_range"
    echo

    files=(
        # "$projectdir/tmp/cumulative_frequency_tables"
        "$projectdir/tmp/frequency_tables" 
        "$projectdir/tmp/relative_frequency_tables" 
    )
    # frequency_tables
    # relative_frequency_tables
    paste ${files[@]} | column -t -N 'shop,receipts,shop,receipts'
    echo

    # cumulative_frequency_tables
    column -t -N 'cost,receipts' $tmp_cumulative_frequency_tables
}


function work
{
    echo -n "Working"
    while true
    do
        local v=$(jobs | grep 'Done')
        [[ -z $v ]] && echo -n "."
        [[ -n $v ]] && echo && break
        sleep 1
    done
}


function main
{
    mean_median_range >> $tmp
    frequency_tables >> $tmp
    put_empty_line
    relative_frequency_table >> $tmp
    put_empty_line
    cumulative_frequency_tables >> $tmp
    put_empty_line

    print_dashboard
}


main &
work
