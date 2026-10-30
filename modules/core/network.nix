{ ... }:

{
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Cloudflare WARP daemon
  services.cloudflare-warp.enable = true;
}
