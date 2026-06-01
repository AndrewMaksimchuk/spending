#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./get_price.bash "$TEST_DIRECTORY/get_price.bash"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "get_price.bash - must read from receipt only price" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_price.bash"
        get_price receipt 
    '

    assert_success
    assert_output "32.40"
}
