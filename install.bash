#!/usr/bin/env bash


cwd=$(dirname $0)


echo "Add to yout shell config file: 'SPENDING_INSTALL=path_to_this_directory'"
echo 'Then add "export PATH=$PATH:$SPENDING_INSTALL"'
echo "Save and reload config file."
echo "Now you have 'spending' application."


[[ ! -e $cwd/spending ]] && ln -s $cwd/spending.bash $cwd/spending
