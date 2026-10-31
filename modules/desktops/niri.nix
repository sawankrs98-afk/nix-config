# ── Niri Scrollable-Tiling Wayland Compositor ────────────────────────────────
#
# Enables the Niri compositor and the iNiR Quickshell-based desktop
# environment (Dank Material Shell).  Bundles XWayland bridging,
# Quickshell with its Qt6 dependencies, theming daemons, and assorted
# CLI helpers required by the iNiR shell scripts.
#
# ─────────────────────────────────────────────────────────────────────────────
{ config, pkgs, ... }:

{
  # ── Compositor ───────────────────────────────────────────────────────────
  programs.niri.enable = true;

  # ── Dank Material Shell ──────────────────────────────────────────────────
  programs.dank-material-shell.enable = true;

  # ── Packages ─────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── XWayland bridge ────────────────────────────────────────────────────
    xwayland-satellite

    # ── Quickshell & Qt6 components ────────────────────────────────────────
    quickshell
    kdePackages.qtdeclarative
    kdePackages.qtwayland
    kdePackages.qtsvg
    kdePackages.qtmultimedia
    kdePackages.qt5compat
    kdePackages.kirigami
    kdePackages.kdialog
    kdePackages.syntax-highlighting

    # ── Theming & wallpaper daemons (iNiR) ─────────────────────────────────
    matugen
    awww

    # ── System tools & CLI helpers (iNiR) ──────────────────────────────────
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

    # ── niri-toggle-maximize ───────────────────────────────────────────────
    # Toggle focused column between half-width (50 %) and full-width (100 %)
    # Bound to Mod+D in the Niri key-map.
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
