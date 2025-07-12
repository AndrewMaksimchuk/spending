#!/usr/bin/env bash

# This file run as ExecStart in spending.service

projectdir=$(dirname $0)

port=6969
save_to=$projectdir/receipts_images
node_argv="$projectdir/web_server.js $port $save_to"

url=$(hostname -I | cut -d' ' -f1)
notify-send "SPENDING application" "Web server start on http://$url:$port"

node  $node_argv
