repl:
	@test -x "$(shell which nix-env 2>/dev/null)" || exit -1
	@test ! -x "$(shell which brew 2>/dev/null)" || exit -1
	nix repl .

switch build dry-activate: 
	@test -x "$(shell which nixos-rebuild 2>/dev/null)" || exit -1
	@test ! -x "$(shell which brew 2>/dev/null)" || exit -1
	@nix flake update --override-input fnctl /media/psf/fnctl
	sudo nixos-rebuild --install-bootloader --flake . $(@F)

.PHONY: repl switch
