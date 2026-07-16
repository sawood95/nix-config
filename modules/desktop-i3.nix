# X11 + i3 desktop stack, adapted from bashbunni/dotfiles' configuration.nix.
{ pkgs, ... }:

{
  services.xserver = {
    enable = true;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3lock
        rofi
      ];
    };
  };

  services.displayManager.defaultSession = "none+i3";
  services.xserver.displayManager.lightdm = {
    enable = true;
    greeters.gtk.enable = true;
  };

  security.polkit.enable = true;
  programs.i3lock.enable = true;

  services.printing.enable = true;

  environment.systemPackages = with pkgs; [
    kitty
    rofi
    flameshot
    xss-lock
    networkmanagerapplet
    playerctl
    pavucontrol
    xclip
    xkill
  ];

  fonts.packages = with pkgs; [
    nerd-fonts.terminess-ttf
    nerd-fonts.blex-mono
    ibm-plex
  ];
  fonts.fontconfig.defaultFonts = {
    sansSerif = [ "IBM Plex Sans" ];
    serif = [ "IBM Plex Serif" ];
    monospace = [ "Terminess Nerd Font" ];
  };
}
