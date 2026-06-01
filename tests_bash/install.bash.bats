#!/bin/bash

load "$PWD/tests_bash/bats_assert/load"
load "$PWD/tests_bash/bats_file/load"

setup() {
    export TEST_HOME
    TEST_HOME="$(mktemp -d)"

    touch "$TEST_HOME/.bashrc"
    touch "$TEST_HOME/.zshrc"

    export HOME="$TEST_HOME"
}

teardown() {
    rm -rf "$TEST_HOME"
}

@test "install.bash - adds PATH configuration to .bashrc" {
    run ./install.bash

    assert_success
    grep -q "SPENDING_INSTALL" "$TEST_HOME/.bashrc"
}

@test "install.bash - adds PATH configuration to .zshrc" {
    run ./install.bash

    assert_success
    grep -q "SPENDING_INSTALL" "$TEST_HOME/.zshrc"
}

@test "install.bash - installs completion for bash" {
    run ./install.bash

    assert_success
    assert_file_exists "$TEST_HOME/.local/share/bash-completion/completions/spending_complete" 
}

@test "install.bash - installs completion for zsh(oh-my-zsh)" {
    run ./install.bash

    assert_success
    assert_file_exists "$TEST_HOME/.oh-my-zsh/completions/_spending" 
}

@test "install.bash - test idempotency" {
    local count

    run ./install.bash
    assert_success

    run ./install.bash
    assert_success

    count=$(grep -c "export SPENDING_INSTALL=" "$TEST_HOME/.bashrc")
    assert_equal "$count" "1"
}
