# PLACEHOLDER — replace this entire file before installing.
#
# On the target machine, boot the NixOS installer and run:
#   sudo nixos-generate-config --root /mnt
# then copy the resulting /mnt/etc/nixos/hardware-configuration.nix over this
# file. It contains the filesystem layout, kernel modules, and CPU
# microcode settings specific to this machine's hardware and cannot be
# guessed in advance.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [ ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  fileSystems."/" = {
    device = "/dev/disk/by-label/REPLACE_ME";
    fsType = "ext4";
  };

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
