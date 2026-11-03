# Upwork desktop app (Electron) built from Upwork's official .deb.
#
# nixpkgs' `upwork` is pinned to 5.8.0.35 and uses `requireFile`, but Upwork
# only serves the current release, so that hash no longer matches. This reuses
# nixpkgs' packaging (autoPatchelf, gapps hook, openssl symlinks) and swaps in
# the .deb kept next to this file.
#
# Updating: download the new .deb, drop it here, bump `version` and the
# filename, then reinstall (see user.nix).
{ pkgs }:

pkgs.upwork.overrideAttrs (old: {
  version = "5.8.0.41";
  src = ./upwork_5.8.0.41_amd64.deb;

  # The nixpkgs wrapper exports LD_LIBRARY_PATH, which every child process
  # inherits. Upwork launches your browser for login, and Firefox then loads
  # Upwork's older libnss3 -> "NSS_3.113 not found". autoPatchelf already
  # bakes the needed RPATH into every binary, so the variable is unnecessary.
  postFixup = ''
    makeWrapper $out/opt/Upwork/upwork $out/bin/upwork \
      --prefix XDG_DATA_DIRS : "${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}"
  '';
})
