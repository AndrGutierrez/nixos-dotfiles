# dotfiles

Single source of truth for this machine's configuration. Nothing is duplicated:
`~/.config/...` holds **symlinks** into this folder, and `/etc/nixos/*.nix`
symlink here too when the system is applied.

```
dotfiles/
├── awesome/rc.lua                 → ~/.config/awesome
├── alacritty/alacritty.toml       → ~/.config/alacritty
├── nvim/init.lua                  → ~/.config/nvim (LazyVim)
├── nvim/lua/config/                 LazyVim options/keymaps/autocmds/lazy
├── nvim/lua/plugins/                custom plugin specs
├── nvim/lazy-lock.json              pinned plugin commits
├── nvim/colors/github_dark.lua      optional colorscheme
├── picom/picom.conf               → ~/.config/picom (yshui/picom sample config)
├── zsh/.zshrc                     → ~/.zshrc (syntax highlighting, fzf, fastfetch)
├── xdg/mimeapps.list              → ~/.config/mimeapps.list
├── xdg/applications/nvim.desktop  → ~/.local/share/applications/nvim.desktop
├── xdg/Xresources                 → ~/.Xresources (cursor theme/size)
├── xdg/gtk-3.0/settings.ini       → ~/.config/gtk-3.0/settings.ini
├── xdg/gtk-3.0/bookmarks          seed: Nautilus NAS bookmark
├── xdg/gtk-4.0/settings.ini       → ~/.config/gtk-4.0/settings.ini
├── xdg/gtk-4.0/servers            seed: Nautilus known SMB connection
├── nixos/configuration.nix        → /etc/nixos/configuration.nix
├── nixos/hardware-configuration.nix → /etc/nixos/hardware-configuration.nix
├── nixos/apply.sh                   sudo: link the above and rebuild
├── upwork/                          Upwork app build (user profile, not root)
├── flake.nix / flake.lock           optional flake entry point (unstable)
└── link.sh                          re-create the ~/.config symlinks
```

## User configs

```bash
./link.sh            # create the symlinks (backs up anything real it finds)
./link.sh --dry-run  # preview
```

Run this after cloning on another machine. After editing:

- **Awesome**: `Super+Ctrl+r` reloads. Bindings: `Super+Enter` terminal,
  `Super+q` Brave, `Super+w` close, main menu moved to `Super+Shift+w`.
  Default layout is **tile** (first entry in `awful.layout.layouts`).
  The UI chrome is a vendored subset of **Crylia** (`crylia_bar/` + `src/`):
  three floating top bars (layout/tags/systray · tasklist · audio/kb/date/clock/power),
  a bottom dock, and left-side macOS-style window titlebars.
  Window gaps are 8.75px (`beautiful.useless_gap`).
  The upstream rc.lua, keybindings, rules, OSDs and picom config are **not** used.
  Nautilus is launched with `GTK_CSD=0 GTK_USE_PORTAL=1` (dock entry + desktop
  file override) so it uses the Awesome titlebar instead of its own header
  buttons, and is dark.
- **Cursor**: `~/.icons/Hornet` (Windows `.ani` pack converted with
  `win2xcur`), size **48** (`32 × 1.5`); `Xcursor.theme`/`GTK` settings point
  at it. Source pack: `~/Downloads/Hornet Cursor Pack.zip`.
- **GTK**: `WhiteSur-Dark` theme + `WhiteSur-dark` icon theme (nixpkgs
  `whitesur-gtk-theme` / `whitesur-icon-theme`), set in `xdg/gtk-3.0|4.0`.
  File manager is **Nautilus** (GNOME Files) — the one shown in WhiteSur's
  screenshots. Note: Nautilus uses libadwaita, which ignores GTK theme names
  (upstream's README documents `./install.sh -l` as the workaround); the
  icon theme does apply.
- **Fonts**: **FiraCode Nerd Font** everywhere — GTK (`gtk-font-name`),
  Alacritty (size 14.4), Awesome (`beautiful.font`), the Crylia bars, and a
  fontconfig alias that maps `sans-serif`/`serif`/`monospace` to it
  (`xdg/fontconfig/fonts.conf`).
- **Launcher**: **rofi** (`rofi-unwrapped`; the nixpkgs wrapper exits on this
  setup). `Super+r` and `Super+d` = apps (`rofi -show drun`),
  `Super+Shift+d` = window switcher, `Super+Shift+r` = old Awesome run prompt.
  Themes: **adi1090x/rofi** collection under `rofi/launchers|applets|colors|
  scripts|powermenu`; the default is the launchpad-style grid
  `launchers/type-3/style-1.rasi` (Iosevka Nerd Font), set via `@theme` in
  `rofi/config.rasi`.
- **Neovim**: LazyVim; `lua/plugins/github-theme.lua` installs
  `projekt0n/github-nvim-theme` and sets `github_dark_default` (Normal bg
  `#0d1117`, identical to Alacritty) as the colorscheme.
- **GTK dark**: `WhiteSur-Dark` in `gtk-3.0|4.0/settings.ini` plus dconf keys
  `color-scheme=prefer-dark`, `gtk-theme=WhiteSur-Dark`. libadwaita apps
  (Nautilus) need `GTK_USE_PORTAL=1` so GTK reads the color scheme from the
  settings portal; `xdg-desktop-portal{,-gtk}` and `programs.dconf.enable`
  provide it.
- **Monitors/compositor**: `rc.lua` applies the dual-screen xrandr layout
  (2560×1440 left @120Hz, 1920×1080 right @120Hz) and starts picom on every
  Awesome start.
- **NAS**: the SMB share `//192.168.1.102/pi` (guest, default port) is mounted
  at `/mnt/nas` at boot so it appears as a device in file managers. `nofail`
  and a 10-second mount timeout keep an offline NAS from blocking boot.
  Nautilus also gets a default sidebar bookmark and a "known connection" for
  `smb://192.168.1.102/pi` (seeded once from `xdg/gtk-3.0/bookmarks` and
  `xdg/gtk-4.0/servers`; Nautilus owns those files afterwards).
- **fastfetch**: config in `fastfetch/config.jsonc` (same modules as default,
  minus `terminalfont`).
- **Shell**: `zsh/.zshrc` loads zsh-syntax-highlighting (fallback until the
  NixOS module is rebuilt), fzf key bindings (`Ctrl+R`/`Ctrl+T`/`Alt+C`) and
  runs `fastfetch` on every interactive shell.
- **Screenshots**: **flameshot** — `Super+Shift+S` (and `Print`) opens the
  region picker (`flameshot gui`).
- **Alacritty**: picked up by every new window.
- **Neovim**: full **LazyVim** setup (the official starter config). `init.lua`
  only loads `lua/config/lazy.lua`; tweak options/keymaps/autocmds in
  `nvim/lua/config/` and add or override plugins in `nvim/lua/plugins/`.
  Plugins live under `~/.local/share/nvim/lazy` and `lazy-lock.json` pins their
  commits. Use `:Lazy`, `:LazyExtras` (enable extra language/framework packs)
  and `:checkhealth lazyvim`. The default theme is `tokyonight`; the old
  `colors/github_dark.lua` is still available if you prefer it.
  LazyVim's external tools (`fd`, `lazygit`, `gcc`, `tree-sitter`, `unzip`,
  `wget`, `xclip`) are in `configuration.nix`, along with `programs.nix-ld` so
  Mason can run downloaded LSP servers; rebuild the system once to get them.

## System config

```bash
sudo bash ~/dotfiles/nixos/apply.sh
```

This links `nixos/configuration.nix` and `nixos/hardware-configuration.nix`
into `/etc/nixos` (backing up real files first) and runs `nixos-rebuild switch`.
The file you edit is always this one.

The session is LightDM → Awesome only; the LXQt desktop environment was removed
(along with `qterminal`).

Alternatively, the flake entry point works too (pinned to nixos-unstable):

```bash
sudo nixos-rebuild switch --flake ~/dotfiles#nixos
```

## Upwork

Installed in the **user profile**, no root needed (the `.deb` is downloaded from
Upwork and is git-ignored):

```bash
nix-env -i -f ~/dotfiles/upwork/user.nix
nix-env -e upwork          # remove
```

## Version control

```bash
git add -A && git commit -m "..."
```

Binaries and build outputs are excluded via `.gitignore`.
