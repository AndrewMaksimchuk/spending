#!/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_DIRECTORY
    TEST_DIRECTORY="$(mktemp -d)"

    # Mock get_shops.bash
    cat > "$TEST_DIRECTORY/get_shops.bash" << 'EOF'
    function get_shop() {
        echo '"silpo"'
    }

    function get_shops() {
        echo "atb"
    }
EOF

    # Mock get_goods.bash
    cat > "$TEST_DIRECTORY/get_goods.bash" << 'EOF'
    function spending_get_goods() {
        echo "батон"
        echo "молоко"
    }
EOF

    mkdir "$TEST_DIRECTORY/tmp/"

    # Mock shop_list
    cat > "$TEST_DIRECTORY/tmp/shop_list" << 'EOF'
    "silpo"
    "eko"
EOF

    mkdir "$TEST_DIRECTORY/receipts/"
    cp ./tests_bash/receipt "$TEST_DIRECTORY/receipts/receipt"

    cp ./awk_validation "$TEST_DIRECTORY/awk_validation"
    cp ./add.bash "$TEST_DIRECTORY/add.bash"
}

teardown() {
    rm -rf "$TEST_DIRECTORY"
}

@test "add.bash - spending_validation_receipt() good receipt" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        spending_validation_receipt ./receipts/receipt
    '

    assert_success
}

@test "add.bash - spending_validation_receipt() receipt missing" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        spending_validation_receipt
    '

    assert_success
    assert_output "Empty receipt, not added!"
}

@test "add.bash - spending_validation_receipt() receipt have bad date format(only check that validation fail)" {
    # Mock get_goods.bash
    cat > "$TEST_DIRECTORY/receipts/receipt" << 'EOF'
        атб
        19:04:2025 14.29.12
        32.40
        =
        =
        category=продукти

EOF

    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        spending_validation_receipt ./receipts/receipt
    '

    assert_failure
    assert_output --partial "[ ERROR ] Date is in bad formatted, should be: dd/mm/yyyy"
}

@test "add.bash - spending_add_goods_if_not_exist() " {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        spending_add_goods_if_not_exist
    '

    assert_success
    assert_file_contains "$TEST_DIRECTORY/tmp/goods" "батон"
    assert_file_contains "$TEST_DIRECTORY/tmp/goods" "молоко"
}

@test "add.bash - check_is_new_shop_exist() shop exist" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        check_is_new_shop_exist "$TEST_DIRECTORY/receipts/receipt"
    '

    assert_success
    assert_file_exists "$TEST_DIRECTORY/tmp/shop_list"
}

@test "add.bash - check_is_new_shop_exist() shop not exist" {
    # Mock shop_list
    cat > "$TEST_DIRECTORY/tmp/shop_list" << 'EOF'
    "eko"
EOF

    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        check_is_new_shop_exist "$TEST_DIRECTORY/receipts/receipt"
    '

    assert_success
    assert_file_not_exists "$TEST_DIRECTORY/tmp/shop_list"
}

@test "add.bash - main() print help message" {
    run bash -c '
        cd "$TEST_DIRECTORY"
        source ./add.bash
        main help
    '

    assert_success
    assert_output --partial "Open nvim with empty file for add content of receipt."
}
