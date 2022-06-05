{
  description = "fnctl/pvm";
  inputs.fnctl.url = "github:fnctl/fnctl";
  outputs = {fnctl, ...}: {
    devShell = fnctl.lib.forEachSupportedSystem (s: fnctl.outputs.devShells.${s}.default);
    formatter = fnctl.lib.forEachSupportedSystem (s: fnctl.outputs.formatter.${s});
    nixosConfigurations.fnctl = fnctl.lib.mkSystem rec {
      system = "aarch64-linux";
      modules = [
        ({
          config,
          pkgs,
          lib,
          ...
        }: {
          disabledModules = ["virtualisation/parallels-guest.nix"];
          imports = [./parallels-guest.nix];

          boot.loader.efi.canTouchEfiVariables = true;
          boot.loader.systemd-boot.enable = true;
          developer.enable = true;
          dnscrypt.enable = true;
          fileSystems."/" .fsType = "ext4";
          fileSystems."/".device = "/dev/disk/by-label/nixos";
          fileSystems."/boot".device = "/dev/disk/by-label/boot";
          fileSystems."/boot".fsType = "vfat";
          networking.interfaces.enp0s5.useDHCP = true;
          nixpkgs.config.allowUnfree = true;
          nixpkgs.config.allowUnsupportedSystem = true;
          services.xserver.enable = true;
          system.fnctl.enableDefaults = true;
          system.stateVersion = "22.05";
          users.defaultUserShell = pkgs.zsh;
        })
      ];
    };
  };
}
