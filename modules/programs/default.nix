# ── Programs Module ──────────────────────────────────────────────────────────
# Aggregates all program-related modules: browsers, editors, programming
# languages, media players, and system utilities.
# ─────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./browsers.nix
    ./editors.nix
    ./languages.nix
    ./media.nix
    ./utils.nix
  ];
}
