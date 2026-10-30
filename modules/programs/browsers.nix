{ pkgs, inputs, ... }:

{
  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    brave
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];
}
