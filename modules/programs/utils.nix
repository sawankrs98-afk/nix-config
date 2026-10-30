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
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity
    inputs.antigravity-nix.packages.${pkgs.stdenv.hostPlatform.system}.google-antigravity-cli

    # Custom rebuild command for Bash, Fish, and all shells
    (writeShellScriptBin "nbuild" ''
      set -e
      if [ "$1" = "home" ]; then
        echo ":: Staging and building flake from ~/nix..."
        git -C "$HOME/nix" add .
        sudo nixos-rebuild switch --flake "$HOME/nix#nixos"
      else
        echo ":: Staging and building flake from current directory..."
        git add .
        sudo nixos-rebuild switch --flake .#nixos
      fi
    '')
  ];
}
