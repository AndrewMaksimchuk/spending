#!/usr/bin/env bash

# The amount of expenses for each month 
# according to the percentage of the salary
# to current year
# Arguments:
#    $1 - the salary value(option)
#    if $1 not present - show calculation

projectdir=$(realpath $(dirname $0))
receipts_dir=$projectdir/receipts
file_salary="$projectdir/tmp/salary"
file_month_price="$projectdir/tmp/salary_month_price"
file_result="$projectdir/tmp/salary_calculation_result"


. $projectdir/get_price.bash
. $projectdir/get_date_month.bash

function print_header
{
    echo -e "\033[1;4mThe amount of expenses of the salary\033[0m"
}

function print_result
{
    cat $file_result
}

function add_salary
{
    local today=$(date +"%d.%m.%Y")
    echo -n $today "$1" >> $file_salary
    exit
}

function get_salary
{
    if [[ ! -e $file_salary ]]; then
        echo "The salary in not set"
        exit
    fi

    salary_value=$(tail -n1 "$file_salary" | cut -f2 -d' ')

    if [[ -z $salary_value ]]; then
        echo "The salary in not set"
        exit
    fi
}

function calc_receipt
{
    local price=$(get_price $1)
    local month=$(get_date_month $receipts_dir/$1)
    echo $month $price
}

function calculation
{
    get_salary
    echo -n > $file_month_price

    local files=$(grep -ws `date +"%Y"` $receipts_dir/** | cut -f1 -d: | rev | cut -f1 -d'/' | rev)
    
    for file in $files
    do
        calc_receipt $file >> $file_month_price
    done

    local range=$(echo {01..12})
    
    for item in $range
    do
        local prices=$(cat $file_month_price | grep "^$item" | cut -f2 -d' ')
        
        if [[ -z $prices ]]; then
            echo $item "0%"
            continue
        
        fi

        local total=$(echo "$prices" | paste -sd+ | bc)
        local percentage=$(echo "$total * 100 / $salary_value" | bc)

        if [[ -z $percentage ]]; then
            echo $item "0%"
            continue
        fi

        echo $item "$percentage%"
    done
}

if [[ -n "$1" ]]; then
    add_salary "$1"
fi

print_header > $file_result
calculation >> $file_result
print_result
