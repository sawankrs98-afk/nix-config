# ── Flake Configuration ──────────────────────────────────────────────
# Top-level flake definition for the NixOS system.
# Declares all external input sources and wires them into the
# single NixOS host configuration ("nixos").
# ─────────────────────────────────────────────────────────────────────
{
  description = "NixOS Flake Configuration";

  # ── Inputs ──────────────────────────────────────────────────────────
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Zen — privacy-focused Firefox fork
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Antigravity — AI coding assistant CLI
    antigravity-nix = {
      url = "github:jacopone/antigravity-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Helium — lightweight Chromium-based browser
    helium = {
      url = "github:schembriaiden/helium-browser-nix-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Dank Material Shell — Material design shell for Wayland (Niri)
    # dank-material-shell = {
    #   url = "github:AvengeMedia/DankMaterialShell";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };

    # iNiR — desktop shell for Niri (prerelease branch)
    inir = {
      url = "github:snowarch/iNiR/prerelease";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # DynamicYou — Material 3 QuickShell rice for Hyprland
    dynamic-you = {
      url = "github:SubhamJM/DynamicYou/nix-support";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  # ── Outputs ─────────────────────────────────────────────────────────
  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };
      modules = [
        # inputs.dank-material-shell.nixosModules.default
        inputs.inir.nixosModules.default
        inputs.dynamic-you.nixosModules.default
        ./hosts/nixos
      ];
    };
  };
}
