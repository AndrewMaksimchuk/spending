#!/usr/bin/env bash

set -euo pipefail
trap 'echo "ERROR on line $LINENO"; exit 1' ERR

cwd=$(dirname "$0")
path=$(readlink -f "$cwd")

function add_completion_bash() {
    local completion_file="$path/spending_complete"

    if [[ ! -f "$completion_file" ]]; then
        echo "Missing spending_complete"
        return 0
    fi

    echo "Add completion for bash"
    local completion_directory=$HOME/.local/share/bash-completion/completions
    mkdir -p "$completion_directory"
    cp -f "$completion_file" "$completion_directory"
}

function add_completion_zsh() {
    local completion_file="$path/_spending"

    if [[ ! -f "$completion_file" ]]; then
        echo "Missing _spending"
        return 0
    fi

    echo "Add completion for zsh(oh-my-zsh)"
    local completion_directory=$HOME/.oh-my-zsh/completions/
    mkdir -p "$completion_directory"
    cp -f "$completion_file" "$completion_directory"
}

function add_completions() {
    add_completion_bash
    add_completion_zsh
}

function addpath() {
    local config="$HOME/$1"

    if [[ ! -f "$config" ]]; then
        return 0
    fi

    if grep -q 'SPENDING_INSTALL' "$config"; then
        return 0
    fi

    echo "Add SPENDING_INSTALL to PATH variable in $1"
    {
        echo ""
        echo "export SPENDING_INSTALL=\"$path\""
        echo 'export PATH="$PATH:$SPENDING_INSTALL"'
    } >> "$config"
}

mkdir -p "$path/tmp"
addpath ".bashrc"
addpath ".zshrc"
add_completions

echo "--------------------------------------------------"
echo "Installation complete."
echo "Restart your shell or run:"
echo "  source ~/.bashrc"
echo "or"
echo "  source ~/.zshrc"
echo "--------------------------------------------------"
