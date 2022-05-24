{
  description = "fnctl/pvm";
  inputs.nixpkgs.url = "nixpkgs/nixos-unstable";
  # inputs.fnctl.url = "github:fnctl/fnctl";
  inputs.fnctl.url = "/media/psf/fnctl";
  inputs.fnctl.inputs.nixpkgs.follows = "nixpkgs";
  outputs = inputs@{ self, nixpkgs, fnctl, ... }: with nixpkgs.lib;
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forEachSupportedSystem = f: genAttrs supportedSystems (system: f system);
    in
    {
      nixosConfigurations = forEachSupportedSystem (system: nixosSystem {
        inherit system;
        modules = [ ./system.nix ];
        specialArgs = {
          inherit system;
          inherit (inputs) nixpkgs fnctl self;
          hostName = "parallels";
        };
      });
    };
}
