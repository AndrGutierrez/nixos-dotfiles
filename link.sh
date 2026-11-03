#!/usr/bin/env bash
# Re-create the symlinks from ~/.config (and ~/.local/share) into ~/dotfiles.
# Idempotent: safe to run after cloning the repo on a fresh machine.
#   ./link.sh            link everything
#   ./link.sh --dry-run  just show what would happen
set -euo pipefail

DOTFILES=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
DRY=0
[ "${1:-}" = "--dry-run" ] && DRY=1

run() {
  if [ "$DRY" = 1 ]; then echo "[dry-run] $*"; else "$@"; fi
}

link() { # link <relative source in dotfiles> <absolute target>
  local src="$DOTFILES/$1" dst="$2"

  if [ ! -e "$src" ]; then
    echo "skip: $src does not exist" >&2
    return 0
  fi

  run mkdir -p "$(dirname "$dst")"

  if [ -L "$dst" ]; then
    if [ "$(readlink -f "$dst")" = "$(readlink -f "$src")" ]; then
      echo "ok:   $dst"
      return 0
    fi
    run rm -f "$dst"
  elif [ -e "$dst" ]; then
    # Real file/dir in the way: back it up, never delete silently.
    run mv "$dst" "$dst.bak-$(date +%Y%m%d-%H%M%S)"
    echo "backup: $dst -> $dst.bak-*"
  fi

  run ln -s "$src" "$dst"
  echo "link: $dst -> $src"
}

seed() { # seed <relative source in dotfiles> <absolute target>
  local src="$DOTFILES/$1" dst="$2"

  if [ ! -e "$src" ]; then
    echo "skip: $src does not exist" >&2
    return 0
  fi

  if [ -e "$dst" ]; then
    echo "keep: $dst"
    return 0
  fi

  run mkdir -p "$(dirname "$dst")"
  run cp "$src" "$dst"
  echo "seed: $dst <- $src"
}

link awesome                   "$HOME/.config/awesome"
link alacritty                 "$HOME/.config/alacritty"
link nvim                      "$HOME/.config/nvim"
link picom                     "$HOME/.config/picom"
link zsh/.zshrc                "$HOME/.zshrc"
link xdg/mimeapps.list         "$HOME/.config/mimeapps.list"
link xdg/applications/nvim.desktop "$HOME/.local/share/applications/nvim.desktop"
link xdg/applications/org.gnome.Nautilus.desktop "$HOME/.local/share/applications/org.gnome.Nautilus.desktop"
link xdg/Xresources            "$HOME/.Xresources"
link xdg/gtk-3.0/settings.ini  "$HOME/.config/gtk-3.0/settings.ini"
link xdg/gtk-4.0/settings.ini  "$HOME/.config/gtk-4.0/settings.ini"
# Seeded once (not symlinked): Nautilus rewrites these as you add connections.
seed xdg/gtk-3.0/bookmarks     "$HOME/.config/gtk-3.0/bookmarks"
seed xdg/gtk-4.0/servers       "$HOME/.config/gtk-4.0/servers"
link xdg/fontconfig/fonts.conf "$HOME/.config/fontconfig/fonts.conf"
link rofi                      "$HOME/.config/rofi"
link fastfetch                 "$HOME/.config/fastfetch"

echo
echo "Done. Edit files in $DOTFILES; the apps pick them up immediately."
