# Installs Upwork into your user profile (no root required):
#
#   nix-env -i -f ~/dotfiles/upwork/user.nix
#
# Remove with:  nix-env -e upwork
let
  pkgs = import <nixpkgs> { config.allowUnfree = true; };
in
{
  upwork = import ./upwork.nix { inherit pkgs; };
}
