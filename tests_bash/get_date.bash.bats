#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    # Mock get_date_time.bash
    {
        echo 'function get_date_time() {'
        echo '    echo "19.04.2025 14:29:12"'
        echo '}'
    } > "$TEST_DIRECTORY/get_date_time.bash"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"
    cp ./get_date.bash "$TEST_DIRECTORY/get_date.bash"

}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "get_date.bash - print date" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./get_date.bash
        get_date ./receipts/receipt
    '

    assert_success
    assert_output "19.04.2025"
}

@test "get_date.bash - print default date if receipt not contain date" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        {
            echo "function get_date_time() {"
            echo "    echo \"\""
            echo "}"
        } > ./get_date_time.bash
        source ./get_date.bash
        get_date ./receipts/receipt
    '

    assert_success
    assert_output "24.02.2022"
}

@test "get_date.bash - exit if file of receipt not exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        rm -rf ./receipts/
        source ./get_date.bash
        get_date ./receipts/receipt
    '

    assert_success
    assert_output --partial " this receipt file not exist"
}
