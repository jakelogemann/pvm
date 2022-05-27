{ config, pkgs, lib, hostName, system, fnctl, ... }@inputs:
let
  nixosConfig = "/media/psf/pvm";

in
with lib; {
  disabledModules = [ "virtualisation/parallels-guest.nix" ];
  imports = [
    ./parallels/module.nix

    fnctl.nixosModules.all
  ];
  developer.enable = true;
  system.fnctl.enableDefaults = true;
  dnscrypt.enable = true;

  sound.enable = mkForce false;
  networking.hostName = hostName;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.enable = true;
  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.allowUnsupportedSystem = true;
  fileSystems."/" .fsType = "ext4";
  fileSystems."/".device = "/dev/disk/by-label/nixos";
  fileSystems."/boot".device = "/dev/disk/by-label/boot";
  fileSystems."/boot".fsType = "vfat";
  networking.interfaces.enp0s5.useDHCP = true;
  services.xserver.enable = true;
  system.stateVersion = "22.05";
  users.defaultUserShell = pkgs.zsh;

  environment.systemPackages = (with pkgs; [
    (writeShellScriptBin "system-edit" "cd ${nixosConfig} && exec vim -p ./*.nix")
    (writeShellScriptBin "system" "exec sudo nixos-rebuild --install-bootloader --flake \"${nixosConfig}#${system}\" \"$@\"")
    (writeShellScriptBin "system-git" "cd ${nixosConfig} && exec sudo git \"$@\"")
    (writeShellScriptBin "system-repl" "cd ${nixosConfig} && exec sudo nix repl")
  ]);

  system.activationScripts.ln-psf-pvm = "test ! -d /media/psf/pvm || echo 'couldn't find /media/psf/pvm' >&2";
  system.activationScripts.check-psf-fnctl = "test ! -d /media/psf/fnctl || echo 'couldn't find /media/psf/fnctl ... ' >&2";
}/*
  vim: et sts=2 ts=2
*/
