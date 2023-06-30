#!/usr/bin/env bash


wd=$(dirname $0)
filename=$(ls -1t $wd/receipts/ | head -1)
file=$(echo "$wd/receipts/$filename")


[[ -e $file ]] && cat $file && exit


echo "Nothing to show"
