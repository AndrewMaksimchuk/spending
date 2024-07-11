#!/usr/bin/env bash


# Pack or unpack receipts archive
# Archive save in path where you run 'spending archive' command
#
# Arguments:
#   $1 - zip or unzip(if omit or 'zip', create archive)
#   $2 - path to archive for unzip


projectdir=$(dirname $0)
cwd=$(pwd)
archive_name=spending_data.zip


if [[ $1 = "unzip" ]]; then
    if [[ -z $2 ]]; then
        echo "Need add full path where archive is with archive name itself"
        exit
    fi

    unzip -o $2 -d $projectdir 1>/dev/null
    echo "Archive was unpack to $projectdir"
    exit
fi


(cd $projectdir && zip -r $cwd/$archive_name receipts/ receipts_images/ 1>/dev/null)
echo "Archive $archive_name save in $cwd"
