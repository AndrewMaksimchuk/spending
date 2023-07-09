#!/usr/bin/env bash


projectdir=$(dirname $0)
. $projectdir/get_shops.bash


usage='Open nvim with empty file for add content of
receipt.
After add all information, run `:xa` for exit 
and save document.
Agruments:
  $1 - "help" show this message'


if [[ $1 = "help" ]]; then
    echo "$usage"
    exit
fi


while true
do
    uuid=$(uuidgen)
    path=$(echo "$projectdir/receipts/$uuid")

    shops=$(get_shops | tr "_" " " | tr -d '"')
    example=$(cat $projectdir/example)
    tempfile=$(mktemp)
    echo "$example" > $tempfile
    echo >> $tempfile
    echo >> $tempfile
    echo "LIST OF SHOPS" >> $tempfile
    echo "$shops" >> $tempfile

    vi +start -O $path $tempfile
    [[ -e $path ]] && echo "$uuid was added" && echo "$path"

    prompt="Add another receipt y/n: "
    read -p "$prompt" input
    [[ $input = "n" ]] && exit
done
