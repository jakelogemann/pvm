install:
	@test -x "$(shell which nix-env 2>/dev/null)" || exit -1
	@test ! -x "$(shell which brew 2>/dev/null)" || exit -1
	test -d /etc/nixos || mkdir -vp /etc/nixos
	cp -Rv ./parallels ./*.nix ./*.lock /etc/nixos/
.PHONY: install

repl:
	@test -x "$(shell which nix-env 2>/dev/null)" || exit -1
	@test ! -x "$(shell which brew 2>/dev/null)" || exit -1
	nix repl ./flake.nix
.PHONY: repl