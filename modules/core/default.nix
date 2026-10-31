# ── Core Modules ─────────────────────────────────────────────────────
# Aggregates all foundational system modules: bootloader, Nix daemon
# settings, audio, networking, locale, user accounts, and Bluetooth.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  imports = [
    ./boot.nix       # Bootloader & kernel
    ./nix.nix        # Nix daemon & flake settings
    ./audio.nix      # PipeWire / sound stack
    ./network.nix    # Hostname, NetworkManager, WARP
    ./locale.nix     # Timezone & i18n locale
    ./user.nix       # User accounts, shell, SSH agent
    ./bluetooth.nix  # Bluetooth hardware support
  ];
}
