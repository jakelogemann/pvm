{
  description = "fnctl/pvm";
  inputs.mkSystem.url = "github:fnctl/mkSystem";
  outputs = {self, ...}:
    with self.inputs.mkSystem; {
      formatter = inputs.fnctl-lib.formatter;
      nixosConfigurations.fnctl = mkSystem rec {
        system = "aarch64-linux";
        modules = [
          ({
            config,
            pkgs,
            lib,
            ...
          }: {
            disabledModules = ["virtualisation/parallels-guest.nix"];
            imports = [
              ./parallels-guest.nix
            ];

            fileSystems."/" .fsType = "ext4";
            fileSystems."/".device = "/dev/disk/by-label/nixos";
            fileSystems."/boot".device = "/dev/disk/by-label/boot";
            fileSystems."/boot".fsType = "vfat";
            networking.interfaces.enp0s5.useDHCP = true;
            nixpkgs.config.allowUnsupportedSystem = true;
            services.xserver.enable = true;
          })
        ];
      };
    };
}
