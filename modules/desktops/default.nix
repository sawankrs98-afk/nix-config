# ── Desktop Environments ─────────────────────────────────────────────────────
#
# Aggregates all desktop environment and compositor modules:
#   • Plasma / GNOME  (plasma.nix)
#   • Hyprland        (hyprland.nix)
#   • Niri            (niri.nix)
#
# ─────────────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./plasma.nix
    ./hyprland.nix
    ./niri.nix
  ];
}
