.PHONY: check format tests_bash tests_lua tests

check:
	@echo "Check bash scripts"
	bash -n *.bash
	shellcheck --color=always *.bash | tee .errors_bash
	@echo "Check lua scripts"
	luac -p *.lua

format:
	stylua *.lua

tests_bash: # https://bats-core.readthedocs.io/en/stable/
	./tests_bash/bats/bin/bats ./tests_bash/*.bats

tests_lua:
	./nvim/bin/nvim --headless -l spending.nvim.plugin.test.lua

tests: tests_bash tests_lua
