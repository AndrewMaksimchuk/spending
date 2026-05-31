#!/bin/bash

# shellcheck disable=all

load "$PWD/tests_bash/bats_assert/load"

@test "get_date_time.bash - get_date_time reads line 2 from receipt" {
    run bash -c '
        source "$PWD/get_date_time.bash"
        get_date_time "$PWD/tests_bash/receipt"
    '

    assert_success
    assert_output "19.04.2025 14:29:12" 
    # [ "$status" -eq 0 ]
    # [ "$output" = "19.04.2025 14:29:12" ]
}
