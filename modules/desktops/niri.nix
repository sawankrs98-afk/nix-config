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

    # Toggle column between half-width (50%) and full-width (100%) for Mod+D
    (writeShellScriptBin "niri-toggle-maximize" ''
      WINDOW=$(${pkgs.niri}/bin/niri msg --json focused-window 2>/dev/null)
      if [ -z "$WINDOW" ] || [ "$WINDOW" = "null" ]; then
          exit 0
      fi

      IS_FLOATING=$(echo "$WINDOW" | ${pkgs.jq}/bin/jq -r '.is_floating // false')
      if [ "$IS_FLOATING" = "true" ]; then
          ${pkgs.niri}/bin/niri msg action maximize-column
          exit 0
      fi

      CURRENT_WIDTH=$(echo "$WINDOW" | ${pkgs.jq}/bin/jq -r '.layout.tile_size[0] // 0' | cut -d. -f1)
      SCREEN_WIDTH=$(${pkgs.niri}/bin/niri msg --json outputs 2>/dev/null | ${pkgs.jq}/bin/jq -r 'to_entries[0].value.logical.width // 1920')
      HALF_SCREEN=$(( SCREEN_WIDTH / 2 ))

      if [ -n "$CURRENT_WIDTH" ] && [ "$CURRENT_WIDTH" -gt "$(( HALF_SCREEN + 50 ))" ]; then
          ${pkgs.niri}/bin/niri msg action set-column-width 50%
      else
          ${pkgs.niri}/bin/niri msg action set-column-width 100%
      fi
    '')
  ];
}
