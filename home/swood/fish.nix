# Adapted from bashbunni/dotfiles' fish config.config.fish — trimmed of the
# macOS/Homebrew paths, personal monitor-layout aliases, and Pomodoro/Love2D
# helpers that don't apply here.
{ ... }:

{
  programs.fish = {
    enable = true;

    shellAliases = {
      g = "git";
      gd = "git diff";
      gs = "git status";
      ga = "git add";
      gc = "git commit -m";
      gp = "git pull";
      latest = "git describe --tags --abbrev=0";
    };

    interactiveShellInit = ''
      set fish_greeting

      set -x EDITOR nvim
      set -x GPG_TTY (tty)

      # Convert ssh-agent output to fish (not done by default when it starts).
      if not set -q SSH_AUTH_SOCK
        eval (ssh-agent -c)
      end

      function fish_prompt
          echo (set_color 87d7af)(date +%H:%M:%S) (set_color 87d7ff)(prompt_pwd) (set_color ffafff)(fish_git_prompt) (set_color ffafff)'→ '
      end
    '';
  };
}
