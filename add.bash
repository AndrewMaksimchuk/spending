#!/usr/bin/env bash


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


cwd=$(dirname $0)


while true
do
    uuid=$(uuidgen)
    path=$(echo "$cwd/receipts/$uuid")

    vi +start -O $path $cwd/example
    [[ -e $path ]] && echo "$uuid was added" && echo "$path"

    prompt="Add another receipt y/n: "
    read -p "$prompt" input
    [[ $input = "n" ]] && exit
done
