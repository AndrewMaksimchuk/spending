#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"

    mkdir "$TEST_DIRECTORY/tmp/"
    touch "$TEST_DIRECTORY/tmp/find_cost"

    # Mock function get_price() from get_price.bash
    {
        echo 'function get_price() {'
        echo '  echo "32.40"'
        echo '}'
    } > "$TEST_DIRECTORY/get_price.bash"

    cp ./find_cost.bash "$TEST_DIRECTORY/find_cost.bash"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "find_cost.bash - show receipt file name that contain specified price" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/find_cost.bash" "32.40"
    '

    assert_success
    assert_output --regexp 'receipt.*32\.40'
    assert_file_exists "$TEST_DIRECTORY/tmp/find_cost"
}
