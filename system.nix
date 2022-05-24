{ config, pkgs, lib, hostName, system, fnctl, ... }@inputs: with lib; {
  disabledModules = [ "virtualisation/parallels-guest.nix" ];
  imports = [
    ./parallels/module.nix

    fnctl.nixosModules.home-manager
    fnctl.nixosModules.fnctl
  ];
  networking.hostName = hostName;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  nixpkgs.config.allowUnfree = true;
  fileSystems."/" .fsType = "ext4";
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  networking.interfaces.enp0s5.useDHCP = true;
  services.xserver.enable = true;
  system.stateVersion = "22.05";

  environment.systemPackages = (with pkgs; [
    (writeShellScriptBin "system-edit" "cd /etc/nixos && exec vim -p ./*.nix")
    (writeShellScriptBin "system" "cd /etc/nixos && exec sudo nixos-rebuild --install-bootloader --flake \".#${system}\" \"$@\"")
    (writeShellScriptBin "system-git" "cd /etc/nixos && exec sudo git \"$@\"")
    (writeShellScriptBin "system-repl" "cd /etc/nixos && exec sudo nix repl")
  ]);

  system.activationScripts.ln-psf-pvm = "test ! -d /media/psf/pvm || echo 'couldn't find /media/psf/pvm' >&2";
  system.activationScripts.check-psf-fnctl = "test ! -d /media/psf/fnctl || echo 'couldn't find /media/psf/fnctl ... ' >&2";
}/*
  vim: et sts=2 ts=2
*/
