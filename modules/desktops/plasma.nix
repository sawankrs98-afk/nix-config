# ── Plasma & GNOME Desktop Configuration ─────────────────────────────────────
#
# Configures KDE Plasma 6 (primary) and GNOME desktop environments,
# SDDM display manager with Wayland, X11 services, keyboard layout,
# and printing settings.
#
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, lib, ... }:

{
  # ── X11 / Display Server ─────────────────────────────────────────────────
  services.xserver.enable = true;

  # ── Display Manager (SDDM) ──────────────────────────────────────────────
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
    theme = "sddm-astronaut-theme";
    extraPackages = with pkgs.kdePackages; [
      qtsvg
      qtmultimedia
      qtvirtualkeyboard
    ];
  };

  # SDDM Astronaut Theme package
  environment.systemPackages = [
    pkgs.sddm-astronaut
  ];

  # Default session launched by the display manager
  services.displayManager.defaultSession = "plasma";

  # ── Desktop Environments ─────────────────────────────────────────────────
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;

  # Resolve conflict between Plasma (ksshaskpass) and GNOME (seahorse)
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # ── Keyboard Layout ─────────────────────────────────────────────────────
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # ── Printing ─────────────────────────────────────────────────────────────
  services.printing.enable = false;
}
