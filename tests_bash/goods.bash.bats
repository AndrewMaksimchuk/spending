#!/usr/bin/bash

load "$PWD/tests_bash/bats_support/load"
load "$PWD/tests_bash/bats_assert/load"

@test "goods.bash - must containe only goods" {
    run ./goods.bash

    assert_success
    refute_output --regexp 'category=|image='
}
