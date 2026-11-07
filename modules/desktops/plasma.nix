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
    theme = "ii-pixel";
    settings = {
      Theme = {
        ThemeDir = "/usr/share/sddm/themes";
      };
    };
    extraPackages = with pkgs.kdePackages; [
      qt5compat
      qtsvg
    ];
  };

  # Ensure SDDM theme directory is writable by user so inir-accel can sync wallpaper/colors
  systemd.tmpfiles.rules = [
    "d /usr/share/sddm/themes 0755 root root -"
    "Z /usr/share/sddm/themes/ii-pixel 0755 kuro users -"
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
