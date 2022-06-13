{
  description = "fnctl/pvm";
  inputs.mkSystem = {
    url = "github:fnctl/mkSystem";
  };
  inputs.fnctl = {
    inputs.fnctl-lib.follows = "mkSystem/fnctl-lib";
    inputs.nixpkgs.follows = "mkSystem/nixpkgs";
    inputs.nix.follows = "mkSystem/nix";
    inputs.home-manager.follows = "mkSystem/home-manager";
    url = "github:fnctl/fnctl";
  };
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
          }: let
            userName = "developer";
            groupName = "fnctl";
          in {
            disabledModules = ["virtualisation/parallels-guest.nix"];
            imports = [
              ./parallels-guest.nix
              ./sway.nix
            ];

            users.groups.${groupName} = {};
            users.groups.docker = {};
            users.groups.users = {};
            users.groups.wheel = {};
            nix.allowedUsers = [userName];
            users.users.${userName} = {
              initialPassword = "${userName}l33t${groupName}!";
              isNormalUser = true;
              group = groupName;
              extraGroups = ["users" "docker" "wheel"];
            };
            home-manager.users.${userName} = import ./home.nix;
            boot.loader.grub.configurationLimit = 10;
            fileSystems."/" .fsType = "ext4";
            fileSystems."/".device = "/dev/disk/by-label/nixos";
            fileSystems."/boot".device = "/dev/disk/by-label/boot";
            fileSystems."/boot".fsType = "vfat";
            networking.interfaces.enp0s5.useDHCP = true;
            nixpkgs.config.allowUnsupportedSystem = true;
            programs.zsh.interactiveShellInit = ''
              autoload -Uz promptinit colors bashcompinit compinit \
              && compinit && bashcompinit && promptinit && colors
            '';
            environment.shellAliases.g = "git";
            security.sudo.wheelNeedsPassword = lib.mkForce false;
            nix.optimise.automatic = true;
            nix.optimise.dates = lib.mkForce ["2h"];
            nix.gc.dates = lib.mkForce "2h";
            programs.starship = {
              enable = true;
              # settings = {
              #   add_newline = false;
              #   format = "$line_break,$package,$line_break,$character";
              #   scan_timeout = 10;
              #   character = {
              #     success_symbol = "➜";
              #     error_symbol = "➜";
              #   };
              # };
            };
          })
        ];
      };
    };
}
