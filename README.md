# nix-config

A flake-based NixOS + Home Manager configuration for the host `verstappen`:
i3 (X11), fish, tmux, and neovim. Based on [bashbunni/dotfiles][bashbunni],
trimmed down and converted to declarative Home Manager modules so a fresh
install is a single `nixos-rebuild switch` — no GNU Stow, no `:PackerSync`,
no `tmux` plugin-manager bootstrap.

[bashbunni]: https://github.com/bashbunni/dotfiles

## Layout

```
flake.nix                        # inputs + nixosConfigurations.verstappen
hosts/verstappen/
  configuration.nix              # system-level config for this host
  hardware-configuration.nix     # PLACEHOLDER — replace on install, see below
modules/
  desktop-i3.nix                 # X11 + i3 + lightdm + fonts (system-level)
home/swood/
  home.nix                       # Home Manager entry point
  fish.nix / git.nix / tmux.nix / neovim.nix
  i3.nix                         # user-level i3 config (xsession)
  i3/config, i3/i3status.conf    # raw i3 / i3status config files
```

## Installing on a fresh machine

1. Boot the NixOS installer, connect to the network, and partition/format
   disks per the [NixOS manual](https://nixos.org/manual/nixos/stable/#sec-installation-partitioning),
   mounting the target filesystem at `/mnt`.

2. Generate hardware config and clone this repo onto the target disk:

   ```sh
   nixos-generate-config --root /mnt
   git clone https://github.com/sawood95/nix-config.git /mnt/etc/nixos
   ```

3. Copy the just-generated hardware config into the repo, replacing the
   placeholder:

   ```sh
   cp /mnt/etc/nixos-generated-hardware-configuration.nix \
      /mnt/etc/nixos/hosts/verstappen/hardware-configuration.nix
   ```

   (If `nixos-generate-config --root /mnt` wrote its output straight into
   `/mnt/etc/nixos/hardware-configuration.nix` before you cloned, just move
   that file into `hosts/verstappen/` instead of `git clone`'s copy.)

4. Install:

   ```sh
   nixos-install --root /mnt --flake '/mnt/etc/nixos#verstappen'
   ```

5. Set a password for `swood` when prompted, reboot, remove the install
   media.

## Updating after install

```sh
cd /etc/nixos
sudo nixos-rebuild switch --flake .#verstappen
```

## Notes / things left out on purpose

- **Git SSH signing / `insteadOf` rewrite**: bashbunni's `.gitconfig` signs
  commits with a Yubikey-backed SSH key and rewrites `https://github.com/`
  to `ssh://`. Both assume a key that doesn't exist on a fresh machine, so
  they're left out of `home/swood/git.nix`. Once you have an SSH key set up
  on GitHub, add to that file:

  ```nix
  settings = {
    commit.gpgsign = true;
    gpg.format = "ssh";
    user.signingkey = "~/.ssh/id_ed25519.pub";
    url."ssh://git@github.com/".insteadOf = "https://github.com/";
  };
  ```

- **Multi-monitor xrandr layout**: `home/swood/i3/config` sets up
  `HDMI-A-2` as primary (4K@120Hz) with `HDMI-A-1` (2560x1440@60Hz, rotated
  left so its bottom edge faces right) to its right. Output names are
  driver-specific — if you're on different hardware, re-check them with
  `xrandr --listmonitors` and update the `exec_always xrandr ...` line.

- **Doom Emacs, sway/swayfx, polybar, waybar**: not carried over — you
  picked i3 + neovim only. `modules/desktop-i3.nix` is where you'd add
  polybar back in if you want it instead of i3bar/i3status.

- **Neovim LSP servers**: installed via nixpkgs (`lua-language-server`,
  `gopls`, `nil`) and wired up directly in `home/swood/neovim.nix` instead
  of Mason, so no runtime download step is needed. Add a server by adding
  its package to `extraPackages` and its lspconfig name to the `for _,
  server in ipairs({...})` loop.
