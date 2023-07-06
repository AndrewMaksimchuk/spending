#!/usr/bin/env bash


usage='Calculate the total cost
Agruments:
  $1 - path to file of list of receipts name'


projectdir=$(dirname $0)


function total_by() {
    [[ ! -e $1 ]] && exit

    filenames=$(cat $1 | grep ^/)
    [[ -z $filenames ]] && exit

    tmpby=$(echo $projectdir/tmp/totalby)
    rm -f $tmpby
    
    for name in $filenames
    do
        name=$(basename $name)
        echo $name >> $tmpby
    done

    names=$(cat $tmpby)
    totalby=$($projectdir/total.bash "$names")
    echo $totalby
}
