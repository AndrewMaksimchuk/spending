check:
	shellcheck --color=always *.bash | tee .errors_bash

format:
	stylua *.lua
