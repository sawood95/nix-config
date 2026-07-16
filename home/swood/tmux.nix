# Adapted from bashbunni/dotfiles' tmux.conf. Plugins are pulled from
# nixpkgs instead of tpm, so there's no `prefix + I` install step needed
# after a fresh install.
{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    mouse = true;
    terminal = "xterm-256color";
    plugins = with pkgs.tmuxPlugins; [
      sensible
      {
        plugin = dracula;
        extraConfig = ''
          set -g @dracula-plugins "battery weather time"
          set -g @dracula-show-powerline true
          set -g @dracula-show-fahrenheit false
          set -g @dracula-military-time true
        '';
      }
    ];
  };
}
