{
  self,
  fnctl,
  system,
  hostName,
  ...
}:
with (fnctl.lib.pkgsForSystem' system);
  mkShell {
    name = hostName;
    buildInputs = [
      gitMinimal
      deadnix
      nix
      alejandra
      (writeShellScriptBin "nixos-rebuild"
        "exec ${lib.getExe nixos-rebuild} --install-bootloader --flake '${self}#${hostName}' \"$@\"")
      (writeShellScriptBin "build" "exec nixos-rebuild build \"$@\"")
      (writeShellScriptBin "switch" "exec sudo nixos-rebuild switch \"$@\"")
    ];
  }
