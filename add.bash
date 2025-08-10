#!/usr/bin/env bash


projectdir=$(dirname "$0")
. "$projectdir/get_shops.bash"


usage="Open nvim with empty file for add content of
receipt.
After add all information, run \`:xa\` for exit 
and save document.
Agruments:
  $1 - \"help\" show this message"

function spending_validation_receipt() {
  if [[ ! -s "$1" ]]; then
    echo "Empty receipt, not added!"
    exit 0
  fi

  awk -f "$projectdir/awk_validation" "$1"
  return $?
}

function check_is_new_shop_exist() {
  local last_shop_name
  local shop_list
  local shops_counter
  last_shop_name=$(get_shop "$1")
  shop_list="$projectdir/tmp/shop_list"
  shops_counter=$(grep -c "$last_shop_name" "$shop_list")

  if [[ $shops_counter -eq 0 ]]; then
    rm -f "$shop_list"
  fi
}


if [[ $1 = "help" ]]; then
    echo "$usage"
    exit
fi


while true
do
    uuid=$(uuidgen)
    path="$projectdir/receipts/$uuid"
    path_temp_receipt=$(mktemp)

    shops=$(get_shops | tr "_" " " | tr -d '"')
    example=$(cat "$projectdir/example")
    tempfile=$(mktemp)
    echo "$example" > "$tempfile"
    {
      echo
      echo
      echo "LIST OF SHOPS"
      echo "$shops"
    } >> "$tempfile"

    "$projectdir/nvim/bin/nvim" -c "source $projectdir/spending.nvim.plugin.lua" +start -O "$path_temp_receipt" "$tempfile"
    spending_validation_receipt "$path_temp_receipt"
    spending_validation_status=$?

    if [[ $spending_validation_status -gt 0 ]]; then
      echo "Fix validation errors above"
      echo "Editor opening..."
      cat "$path_temp_receipt" > "$path"
      sleep 3
      "$projectdir/nvim/bin/nvim" +start -O "$path" "$tempfile"
    else
      cat "$path_temp_receipt" > "$path"
    fi

    [[ -e $path ]] && echo "$uuid was added" && echo "$path"

    check_is_new_shop_exist "$uuid"    

    prompt="Add another receipt y/n: "
    read -r -p "$prompt" input
    [[ $input = "n" ]] && exit
done
