rec {
  description = "virtual machine";

  inputs.fnctl = {
    url = "github:fnctl/nix";
    inputs.nixpkgs.follows = "nixpkgs";
  };
  inputs.nixpkgs.url = "nixpkgs/nixos-22.05";

  outputs = {
    self,
    fnctl,
    nixpkgs,
  } @ inputs: {
    formatter = fnctl.outputs.formatter;
    devShells = fnctl.lib.eachSystemMap (s: { default = import ./shell.nix self s ; });
    overlays.default = import ./overlay/default.nix inputs;
    nixosConfigurations.default = import ./system.nix inputs;
    nixConfig = {
      bash-prompt = ">";
      bash-prompt-suffix = " ";
      flake-registry = ./flake.registry.json;
    };
  };
}
