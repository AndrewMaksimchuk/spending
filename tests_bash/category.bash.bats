#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    cp ./category.bash "$TEST_DIRECTORY/category.bash"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "categoty.bash - show availabel categories" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        echo "продукти" > ./category_list
        source ./category.bash
    '

    assert_success
    assert_output "продукти"
}

@test "categoty.bash - add new category to category_list file" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./category.bash add test_category
    '

    assert_success
    assert_output --partial " is added"
    assert_file_contains "$TEST_DIRECTORY/category_list" test_category
}

@test "categoty.bash - add new category to category_list file but forgot write name of category" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./category.bash add
    '

    assert_success
    assert_output "Try again but add the name of category"
}
