#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    # Mock get_shop.bash
    {
        # shellcheck disable=SC2329
        echo 'function get_shop() {'
        echo '    echo \"atb\"'
        echo '}'
    } > "$TEST_DIRECTORY/get_shop.bash"

    cp ./get_shops.bash "$TEST_DIRECTORY/get_shops.bash"

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"

    mkdir "$TEST_DIRECTORY/tmp/"
    touch "$TEST_DIRECTORY/tmp/shops"

    {
        echo 'silpo'
    } > "$TEST_DIRECTORY/tmp/shop_list"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "get_shops.bash - prints()" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_shops.bash"
        prints "$PWD/receipts/receipt"
    '

    assert_success
    assert_file_exists "$TEST_DIRECTORY/tmp/shops"
    assert_file_contains "$TEST_DIRECTORY/tmp/shops" atb
}

@test "get_shops.bash - get_shops() when file shop_list exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source "$PWD/get_shops.bash"
        get_shops
    '

    assert_success
    assert_output silpo
}

@test "get_shops.bash - get_shops() when file shop_list not exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        rm "$TEST_DIRECTORY/tmp/shop_list"
        source "$PWD/get_shops.bash"
        get_shops
    '

    assert_success
    assert_output '"atb"' # because function get_shop return shop name in double quotes
}
