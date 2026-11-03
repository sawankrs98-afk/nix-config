# ── Utilities ─────────────────────────────────────────────────────────────────
# Shell prompt, fonts, terminal emulator, system monitoring, Discord client,
# custom rebuild scripts, and Antigravity tools (from flake inputs).
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, inputs, ... }:

{
  # ── Shell Prompt ───────────────────────────────────────────────────────
  programs.starship = {
    enable = true;
  };

  # ── Fonts ──────────────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    nerd-fonts.mononoki      # Mononoki Nerd Font (coding font)
    nerd-fonts.symbols-only  # Nerd Font symbols (icon glyphs)
  ];

  # ── Packages ───────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── Core Tools ───────────────────────────────────────────────────────
    git                                                                            # Version control
    kitty                                                                          # GPU-accelerated terminal
    vesktop                                                                        # Discord client (Vencord)
    fastfetch                                                                      # System info fetcher
    btop
    libreoffice
    qbittorrent
    obsidian
    kdePackages.filelight                                                                           # System resource monitor
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity      # Antigravity GUI
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli  # Antigravity CLI

    # ── NixOS Rebuild Helper ─────────────────────────────────────────────
    # Rebuild system configuration from ~/nix
    (writeShellScriptBin "nbuild" ''
      set -e
      echo ":: Staging and building NixOS from ~/nix..."
      git -C "$HOME/nix" add .
      sudo nixos-rebuild switch --flake "$HOME/nix#nixos" "$@"
    '')

    # ── NixOS Update & Rebuild Helper ────────────────────────────────────
    # Update flake inputs and rebuild system configuration
    (writeShellScriptBin "nupdate" ''
      set -e
      echo ":: Updating flake inputs in ~/nix..."
      cd "$HOME/nix"
      nix flake update
      git -C "$HOME/nix" add flake.lock
      echo ":: Rebuilding NixOS from ~/nix..."
      sudo nixos-rebuild switch --flake "$HOME/nix#nixos" "$@"
    '')

    # ── 5 GHz Wi-Fi Hotspot Controls ─────────────────────────────────────
    # Start high-speed 5 GHz hotspot (SSID: saksham)
    (writeShellScriptBin "hotspot-on" ''
      set -e
      echo ":: Starting 5 GHz Hotspot (SSID: saksham)..."
      nmcli connection up "Hotspot-5GHz"
      echo ":: Hotspot ACTIVE! SSID: saksham | Band: 5 GHz (Ch 36) | Password: zyta5466"
    '')

    # Stop hotspot and return Wi-Fi to standard client mode
    (writeShellScriptBin "hotspot-off" ''
      set -e
      echo ":: Stopping 5 GHz Hotspot..."
      nmcli connection down "Hotspot-5GHz" || true
      echo ":: Hotspot stopped. Wi-Fi returned to client mode."
    '')
  ];
}
