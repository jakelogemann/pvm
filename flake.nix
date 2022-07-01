{
  description = "virtual machine";

  inputs.fnctl = {
    url = "github:fnctl/fnctl.nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = inputs: let
    inputs.system = "aarch64-linux";
    inputs.hostName = "pvm";
  in
    with inputs; {
      # I prefer the alejandra formatter, similar to FnCtl.
      inherit (fnctl.outputs) formatter;
      overlays.default = import ./overlays/default.nix inputs;
      devShells.${system}.default = import ./shell.nix inputs;
      nixosConfigurations.${hostName} = import ./system.nix inputs;
      nixConfig = {
        bash-prompt = "pvm";
        bash-prompt-suffix = "> ";
        flake-registry = ./flake.registry.json;
      };
    };
}
