#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    cp ./archive.bash "$TEST_DIRECTORY/archive.bash"

    mkdir "$TEST_DIRECTORY/receipts/"
    mkdir "$TEST_DIRECTORY/receipts_images/"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "archive.bash - zip" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "./archive.bash"
    '

    assert_success
    assert_output "Archive spending_data.zip save in $TEST_DIRECTORY"
    assert_file_exists "$TEST_DIRECTORY/spending_data.zip"
}

@test "archive.bash - unzip" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "./archive.bash"
        rm -rf "./receipts/"
        rm -rf "./receipts_images/"
        source "./archive.bash" unzip "$TEST_DIRECTORY/spending_data.zip"
    '

    assert_success
    assert_output --partial "Archive was unpack to "
    assert_dir_exists "$TEST_DIRECTORY/receipts/"
    assert_dir_exists "$TEST_DIRECTORY/receipts_images/"
}
