#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./get_shop.bash "$TEST_DIRECTORY/get_shop.bash"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "get_shop.bash - must read from receipt only shop name" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_shop.bash"
        get_shop receipt 
    '

    assert_success
    assert_output '"атб"'
}

@test "get_shop.bash - must exit with message, miss receipt file name" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_shop.bash"
        get_shop 
    '

    assert_success
    assert_output "Argument not provided" 
}

@test "get_shop.bash - must exit with message, receipt file not exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_shop.bash"
        get_shop receipts 
    '

    assert_success
    assert_output "receipts not exist"
}
