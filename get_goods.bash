#!/usr/bin/env bash


# Get goods of receipt
# Arguments:
#   $1 - file name(without path)


projectdir=$(dirname $0)


function spending_get_goods() {
  sed -n '/^=/,/^=/p' "$1" | head -n -1 | tail -n +2
}
