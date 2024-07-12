#!/usr/bin/env bash

# Start web server for load and save receipts images

function server() {
    local nodejs=$(whereis -b node | cut -d: -f2)

    if [[ -z $nodejs ]];then
        echo 'Can`t fine node.js! Please install for use this option'
        exit
    fi

    local projectdir=$(dirname $0)
    local save_to=$projectdir/receipts_images
    local ip_host=$(hostname -I | tr -d [:blank:])
    local port=6969
    local node_argv="$projectdir/web_server.js $port $save_to"
    local pid=$(ps aux | grep "$node_argv" | head -n1 | awk '{print $2}')

    if [[ -n $pid ]];then
        kill $pid 1>/dev/null 2>/dev/null
    fi

    if [[ -z $ip_host ]];then
        ip_host=localhost
    fi

    echo "Web server start work on: $ip_host:$port"
    node  $node_argv &

    if [[ $ip_host = "localhost" ]];then
        xdg-open "http://localhost:$port" 1>/dev/null 2>/dev/null
    fi
}

server
