{ pkgs, inputs, ... }:

{
  programs.starship = {
    enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.mononoki
    nerd-fonts.symbols-only
  ];

  environment.systemPackages = with pkgs; [
    git
    kitty
    vesktop
    fastfetch
    btop
    asusctl
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli

    # Rebuild system configuration from ~/nix
    (writeShellScriptBin "nbuild" ''
      set -e
      echo ":: Staging and building NixOS from ~/nix..."
      git -C "$HOME/nix" add .
      sudo nixos-rebuild switch --flake "$HOME/nix#nixos" "$@"
    '')

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
