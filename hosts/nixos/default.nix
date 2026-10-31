# ── Host: nixos ──────────────────────────────────────────────────────
# Machine-specific entry point.  Pulls in hardware config and all
# shared module bundles (core, desktops, programs), then adds any
# host-only tweaks.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── Module Imports ──────────────────────────────────────────────────
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops
    ../../modules/programs
  ];

  # ── Battery Health ──────────────────────────────────────────────────
  # Automatically cap battery charge at 80 % on boot / plug-in to
  # extend long-term battery lifespan.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="BAT[0-9]", ATTR{charge_control_end_threshold}=="*", ATTR{charge_control_end_threshold}="80"
  '';
}
