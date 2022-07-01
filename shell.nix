self: system:
with (self.inputs.fnctl.lib.pkgsForSystem' system);
  mkShell {
    name = "devShell";
    buildInputs = [
      gitMinimal
      deadnix
      nix
      alejandra
      (writeShellScriptBin "nixos-rebuild"
        "exec ${lib.getExe nixos-rebuild} --install-bootloader --flake '${self}#default' \"$@\"")
      (writeShellScriptBin "build" "exec nixos-rebuild build \"$@\"")
      (writeShellScriptBin "switch" "exec sudo nixos-rebuild switch \"$@\"")
    ];
  }
