{ pkgs, username, ... }:

{
  imports = [
    ./fish.nix
    ./git.nix
    ./tmux.nix
    ./neovim.nix
    ./i3.nix
  ];

  home.username = username;
  home.homeDirectory = "/home/${username}";

  # Matches the NixOS release used at first install (see hosts/verstappen's
  # system.stateVersion comment) — do not bump this on later upgrades.
  home.stateVersion = "25.05";

  home.packages = with pkgs; [
    ripgrep
    fd
  ];

  programs.home-manager.enable = true;
}
