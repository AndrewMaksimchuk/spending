#!/usr/bin/env bash


usage='Delete all receipts and temp files
Agruments:
  $1 - "help" show this message'


if [[ $1 = "help" ]]; then
    echo "$usage"
    exit
fi


project_dir=$(dirname $0)


rm -rf $project_dir/receipts/*
rm -rf $project_dir/tmp/*
