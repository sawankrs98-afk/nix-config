# ── Hyprland Wayland Compositor ───────────────────────────────────────────────
#
# Enables the Hyprland dynamic tiling compositor with XWayland support,
# bundles common Wayland desktop utilities (bars, launchers, clipboard,
# screenshot tools, lock screens), and sets session variables for native
# Wayland rendering in Electron / Chromium apps.
#
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Compositor ───────────────────────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # ── DynamicYou Shell & Rice ──────────────────────────────────────────────
  programs.dynamic-you = {
    enable = true;
    installFonts = true;
  };

  # ── Wayland Desktop Packages ─────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Bars, launchers & notifications
    waybar
    rofi
    fuzzel
    #dunst
    #mako

    # Clipboard, screenshot & screen utilities
    wl-clipboard
    cliphist
    grim
    slurp
    swappy
    swaybg
    hyprpaper
    hyprlock
    hypridle
    wlogout

    # Audio, brightness & media controls
    pavucontrol
    brightnessctl
    playerctl
    libnotify

    # Terminal emulators
    kitty
    foot
  ];

  # ── Session Variables ────────────────────────────────────────────────────
  # Hint Electron & Chromium apps to run natively on Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
