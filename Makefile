check:
	bash -n *.bash
	shellcheck --color=always *.bash | tee .errors_bash

format:
	stylua *.lua

tests: # https://bats-core.readthedocs.io/en/stable/
	./tests_bash/bats/bin/bats ./tests_bash/*.bats
