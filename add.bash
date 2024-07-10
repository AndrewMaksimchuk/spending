#!/usr/bin/env bash


projectdir=$(dirname $0)
. $projectdir/get_shops.bash


usage='Open nvim with empty file for add content of
receipt.
After add all information, run `:xa` for exit 
and save document.
Agruments:
  $1 - "help" show this message'


function check_is_new_shop_exist() {
  local last_shop_name=$(get_shop "$1")
  local shop_list=$(echo $projectdir/tmp/shop_list)
  local shops_counter=$(grep "$last_shop_name" $shop_list | wc -l)

  if [[ $shops_counter -eq 0 ]]; then
    rm -f $shop_list
  fi
}


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

    check_is_new_shop_exist "$uuid"    

    prompt="Add another receipt y/n: "
    read -p "$prompt" input
    [[ $input = "n" ]] && exit
done
