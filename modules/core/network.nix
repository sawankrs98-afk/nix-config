# ── Networking ───────────────────────────────────────────────────────
# Sets the hostname, enables NetworkManager for Wi-Fi / wired
# connections, and starts the Cloudflare WARP VPN daemon.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── Hostname ────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  # ── NetworkManager ──────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  # ── Cloudflare WARP ─────────────────────────────────────────────────
  # Provides encrypted DNS and optional VPN tunneling via WARP daemon.
  services.cloudflare-warp.enable = true;
}
