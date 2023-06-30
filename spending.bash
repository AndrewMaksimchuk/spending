#!/usr/bin/env bash


cwd=$(dirname $0)


. $cwd/usage.bash


if [ $# -eq 0 ]; then
    usage
    exit
fi


case $1 in 

  "add")
    "$cwd/add.bash"
    ;;

  "total") 
    "$cwd/total.bash"
    ;;

  *) 
    echo "Command not valid"
    usage 
    ;; 
esac
