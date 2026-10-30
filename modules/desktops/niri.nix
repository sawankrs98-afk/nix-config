{ config, pkgs, ... }:

{
  # Enable Niri scrollable-tiling Wayland compositor
  programs.niri.enable = true;

  # Enable Dank Material Shell
  programs.dank-material-shell.enable = true;

  # Packages required for Niri and the iNiR Quickshell desktop environment
  environment.systemPackages = with pkgs; [
    # Niri & XWayland support
    xwayland-satellite

    # Quickshell & Qt6 components
    quickshell
    kdePackages.qtdeclarative
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qt5compat
    kdePackages.kirigami
    kdePackages.kdialog
    kdePackages.syntax-highlighting

    # Theming & Wallpaper daemons for iNiR
    matugen
    awww

    # iNiR system tools & CLI helpers
    socat
    bc
    jq
    imagemagick
    wlsunset
    wtype
    ydotool
    hyprpicker
    wf-recorder
    swappy
    libqalculate
    upower
    uv
    mpv
    ffmpeg
    yt-dlp
    swaylock
    swayidle
    kdePackages.plasma-integration
    (python3.withPackages (ps: with ps; [ pillow ]))
  ];
}
