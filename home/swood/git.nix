# Adapted from bashbunni/dotfiles' gitconfig. Signing/SSH-insteadOf are left
# out since they depend on keys this repo can't assume exist on a fresh
# install — see the top-level README for how to turn them back on.
{ ... }:

{
  programs.git = {
    enable = true;

    settings = {
      user.name = "Stephen Wood";
      user.email = "swood95@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      core.editor = "nvim";

      alias = {
        st = "status";
        cm = "commit -m";
        p = "push";
        pf = "push --force-with-lease";
        wa = "worktree add";
        wl = "worktree list";
        wd = "worktree remove";
        pretty = "log --pretty=format:'%h %ad | %s%d [%an]' --graph --date=short";
      };
    };
  };
}
