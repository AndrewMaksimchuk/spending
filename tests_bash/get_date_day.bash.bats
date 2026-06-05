#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    # Mock get_date.bash
    {
        echo 'function get_date() {'
        echo '    echo "24.02.2022"'
        echo '}'
    } > "$TEST_DIRECTORY/get_date.bash"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"
    cp ./get_date_day.bash "$TEST_DIRECTORY/get_date_day.bash"

}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "get_date_day.bash - print day" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./get_date_day.bash
        get_date_day ./receipts/receipt
    '

    assert_success
    assert_output "24"
}

@test "get_date_day.bash - exit if file of receipt not exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        rm -rf ./receipts/
        source ./get_date_day.bash
        get_date_day ./receipts/receipt
    '

    assert_success
}
