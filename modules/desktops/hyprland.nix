{ config, pkgs, ... }:

{
  # Enable Hyprland compositor
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Wayland desktop components & utilities commonly used with Hyprland
  environment.systemPackages = with pkgs; [
    # Bars & Launchers & Notifications
    waybar
    rofi
    fuzzel
    #dunst
    #mako

    # Wayland utilities
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
    pavucontrol
    brightnessctl
    playerctl
    #libnotify

    # Terminal emulators
    kitty
    foot
  ];

  # Hint Electron & Chromium apps to run natively on Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
}
