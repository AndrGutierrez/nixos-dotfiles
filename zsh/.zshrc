# ~/.zshrc — user-level additions on top of the system /etc/zshrc.
#
# /etc/zshrc (NixOS) sets up oh-my-zsh, Starship and — after the pending
# rebuild — zsh-syntax-highlighting and the login shell. Everything here is
# safe to load both before and after that rebuild.

# --- zsh-syntax-highlighting ------------------------------------------------
# Fish-style highlighting while typing. The NixOS module provides it globally;
# until that rebuild lands, fall back to the copy in the user profile. The
# version variable prevents double loading once /etc/zshrc has it.
if (( ! ${+ZSH_HIGHLIGHT_VERSION} )); then
  _zsh_hl="$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
  [[ -r "$_zsh_hl" ]] && source "$_zsh_hl"
  unset _zsh_hl
fi

# --- fzf --------------------------------------------------------------------
# Ctrl+R history, Ctrl+T files, Alt+C cd. `fzf --zsh` emits bindings and
# completion for the installed version.
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# --- fastfetch on every terminal -------------------------------------------
# Interactive shells only, so `zsh -c ...` stays quiet.
if [[ -o interactive ]] && (( $+commands[fastfetch] )); then
  fastfetch
fi
