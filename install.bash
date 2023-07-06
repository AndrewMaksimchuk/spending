#!/usr/bin/env bash


cwd=$(dirname $0)
path=$(readlink -f $cwd)


function addpath() {
    user=$(who -s | head -1 | awk '{print $1}')
    config=$(echo "/home/$user/$1")

    [[ ! -e $config ]] && return 0

    is_set_env=$(cat $config | grep "SPENDING_INSTALL")
    [[ -n $is_set_env ]] && return 0

    echo >> $config
    echo "export SPENDING_INSTALL=\"$path\"" >> $config
    echo 'export PATH="$PATH:$SPENDING_INSTALL"' >> $config
}


addpath ".bashrc"
addpath ".zshrc"


cp -f $cwd/spending_complete /etc/bash_completion.d/


if [[ -d /usr/share/zsh/vendor-completions/ ]]; then
    cp -f $cwd/_spending /usr/share/zsh/vendor-completions/
fi
