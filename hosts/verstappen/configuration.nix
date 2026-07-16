# System-level configuration for "verstappen".
#
# Before the first `nixos-rebuild switch`, replace hardware-configuration.nix
# in this directory with the one generated on the real machine by
# `nixos-generate-config` (see the top-level README).
{ config, pkgs, username, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/desktop-i3.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.kernelPackages = pkgs.linuxPackages_latest;

  networking.hostName = "verstappen";
  networking.networkmanager.enable = true;

  time.timeZone = "America/New_York";
  i18n.defaultLocale = "en_US.UTF-8";

  # Audio via pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    description = "Stephen Wood";
    extraGroups = [ "networkmanager" "wheel" "video" ];
    shell = pkgs.fish;
  };
  programs.fish.enable = true;

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    wget
    git
    vim
  ];

  services.openssh.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Verify with `nixos-version`
  # after the first install and adjust if this doesn't match — it should
  # NOT be bumped afterwards just to track upgrades.
  system.stateVersion = "25.05";
}
