#!/usr/bin/env bash
# Link the NixOS config from this dotfiles repo into /etc/nixos and rebuild.
#
#   sudo bash ~/dotfiles/nixos/apply.sh
#
# /etc/nixos/configuration.nix becomes a symlink to this folder, so there is
# only ever one copy of the config: this one.
set -euo pipefail

HERE=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
ETC=/etc/nixos

if [ "$(id -u)" -ne 0 ]; then
  echo "This needs root. Run:  sudo bash $HERE/apply.sh" >&2
  exit 1
fi

for f in configuration.nix hardware-configuration.nix; do
  if [ ! -f "$HERE/$f" ]; then
    echo "Missing $HERE/$f" >&2
    exit 1
  fi
done

# Safety: never link something that is not our config.
if ! grep -q "windowManager.awesome.enable" "$HERE/configuration.nix"; then
  echo "Refusing: $HERE/configuration.nix does not contain the Awesome settings." >&2
  exit 1
fi

STAMP=$(date +%Y%m%d-%H%M%S)
for f in configuration.nix hardware-configuration.nix; do
  dst="$ETC/$f"
  if [ -e "$dst" ] && [ ! -L "$dst" ]; then
    cp -a "$dst" "$dst.bak-$STAMP"
    echo "==> Backed up $dst -> $dst.bak-$STAMP"
  fi
  mkdir -p "$ETC"
  ln -sfn "$HERE/$f" "$dst"
  echo "==> Linked $dst -> $HERE/$f"
done

nixos-rebuild switch
echo
echo "==> Done. Log out and back in to start the Awesome session."
