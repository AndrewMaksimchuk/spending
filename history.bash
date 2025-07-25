#!/usr/bin/env bash

# Show history by months
# in current year
# Arguments:
#    $1 - month(not implemented)
#    $2 - year

projectdir=$(realpath $(dirname $0))
receipts=$(. $projectdir/show_year.bash $2)
file_history="$projectdir/tmp/history"
month_names='January;February;March;April;May;June;July;August;September;October;November;December'
current_month=$(date +"%m")

function formated {
    local data=$(echo "$receipts" | grep -A 3 -e "^/" | grep -v -e "^/" | sed "s/--//g")
    local data_column=$(echo "$data" | sed '/^$/d' | pr -ats --columns 3)

    rm -f $file_history

    echo "$data_column" | while read line; do
        local date_cost=$(echo $line | rev | awk '{print $1" "$2" " $3" "}' | rev)
        local shop=$(echo $line | rev | awk '{ $1=""; $2=""; $3=""; print $0}' | rev | tr " " "_" | sed 's/___//g')
        local row=$(echo "$date_cost" "$shop")
        echo "$row" >>$file_history
    done

    local table=$(cat $file_history |
        sort --field-separator=. -n -k 2.1 -k 1.1 |
        column -t -R 3 -N Date,Time,Cost,Shop)
    echo "$table" >$file_history
}

function spending_month_summary_calculation {
    # $1 - content of history file
    # $2 - number of month
    local spending_month_summary=0

    echo "$1" | while read line;
    do
        local month_line=$(echo "$line" | cut -d. -f2)
        if [[ $month_line = $2 ]]; then
            local current_receipt_price=$(echo "$line" | awk '{print $3}')
            spending_month_summary=$(echo "$spending_month_summary + $current_receipt_price" | bc)
            echo "$spending_month_summary"
        fi
    done
}

function spending_data_month_calculation {
        cat "$file_history" | tail -n +2 | while read line; do
            local month_line=$(echo $line | cut -d. -f2)
            if [[ $month_line = $1 ]]; then
                echo $line
            fi
        done
}

function main {
    formated

    local content_of_history_file=$(cat "$file_history" | tail -n +2)

    for value in $(seq -w 01 $current_month); do
        local spending_month_summary=$(spending_month_summary_calculation "$content_of_history_file" "$value" | tail -n -1)
        local current_month_name=$(echo $month_names | cut -d ';' -f $value)

        echo $current_month_name
        echo '=========='
        spending_data_month_calculation $value | column -t -R 3
        echo "summary     $spending_month_summary"
        echo
    done
}

main
