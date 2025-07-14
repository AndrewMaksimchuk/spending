#!/usr/bin/env bash

projectdir=$(dirname $0)
spending_receipts_directory="$projectdir/receipts"
spending_search_file_tmp="$projectdir/tmp/search"

grep --recursive --ignore-case -C 1 "--regexp=$1" "$spending_receipts_directory"
