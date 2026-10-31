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
    btop                                                                           # System resource monitor
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
  ];
}
