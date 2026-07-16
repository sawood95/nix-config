# Adapted from bashbunni/dotfiles' i3 config: same keybindings/Dracula
# theme, minus the per-machine xrandr monitor layout and the Doom Emacs
# bind. Kept i3bar+i3status (what her config actually runs) instead of
# polybar to cut down on moving parts — swap in modules/desktop-i3.nix's
# polybar package plus a status_command change here if you want it back.
{ ... }:

{
  xsession.enable = true;
  xsession.windowManager.i3 = {
    enable = true;
    config = null;
    extraConfig = builtins.readFile ./i3/config;
  };

  xdg.configFile."i3status/config".source = ./i3/i3status.conf;
}
