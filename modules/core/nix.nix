{ ... }:

{
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # Enable Flakes and new nix command
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
