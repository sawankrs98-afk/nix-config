# ── Networking ───────────────────────────────────────────────────────
# Sets the hostname, enables NetworkManager for Wi-Fi / wired
# connections, configures Cloudflare WARP, and sets up high-speed
# 5 GHz Wi-Fi hotspot sharing with firewall rules.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── Hostname ────────────────────────────────────────────────────────
  networking.hostName = "nixos";

  # ── NetworkManager ──────────────────────────────────────────────────
  networking.networkmanager = {
    enable = true;

    # ── Declarative 5 GHz Hotspot Profile ─────────────────────────────
    # Creates the profile but autoconnect is false so it is only active
    # when started via `hotspot-on` or `nmcli con up Hotspot-5GHz`.
    ensureProfiles.profiles = {
      "Hotspot-5GHz" = {
        connection = {
          id = "Hotspot-5GHz";
          type = "wifi";
          autoconnect = "false";
          interface-name = "wlp4s0";
        };
        wifi = {
          mode = "ap";
          ssid = "saksham";
          band = "a";          # 5 GHz band ("a" = 5 GHz, "bg" = 2.4 GHz)
          channel = "36";       # 5180 MHz non-DFS channel (instant broadcast, 80 MHz width)
        };
        wifi-security = {
          key-mgmt = "wpa-psk";
          psk = "zyta5466";
          proto = "rsn";        # WPA2 (RSN)
          pairwise = "ccmp";    # Hardware-accelerated AES-CCMP
          group = "ccmp";
        };
        ipv4 = {
          method = "shared";    # Internal NAT / DHCP server (10.42.0.1)
        };
        ipv6 = {
          method = "ignore";    # Prevent timeout if upstream lacks IPv6 prefix delegation
        };
      };
    };
  };

  # ── Kernel Networking & Routing ─────────────────────────────────────
  boot.kernel.sysctl = {
    # Enable IPv4 packet forwarding between interfaces (required for internet sharing)
    "net.ipv4.ip_forward" = 1;
  };

  # Set regulatory domain so 5 GHz Channel 36 is not blocked by world '00' no-IR restrictions
  boot.extraModprobeConfig = ''
    options cfg80211 ieee80211_regdom="IN"
  '';

  # ── Firewall Configuration ──────────────────────────────────────────
  networking.firewall = {
    enable = true;

    # Avoid dropping forwarded cross-interface packets (e.g. from hotspot out to WAN/WARP)
    checkReversePath = "loose";

    # Scoped strictly to the wireless interface: allow DHCP (67/68) & DNS (53)
    # This prevents blocking hotspot clients without exposing ports to public Wi-Fi
    interfaces."wlp4s0" = {
      allowedUDPPorts = [ 53 67 68 ];
      allowedTCPPorts = [ 53 ];
    };
  };

  # ── Cloudflare WARP ─────────────────────────────────────────────────
  # Provides encrypted DNS and optional VPN tunneling via WARP daemon.
  services.cloudflare-warp.enable = true;

  # ── Tailscale Mesh VPN ──────────────────────────────────────────────
  services.tailscale.enable = true;
  networking.firewall.trustedInterfaces = [ "tailscale0" ];

  # ── Geolocation ─────────────────────────────────────────────────────
  # Used by iNiR weather and night light
  services.geoclue2.enable = true;
}
