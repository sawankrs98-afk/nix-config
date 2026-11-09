# ── Media & Entertainment ────────────────────────────────────────────────────
# Music streaming, video playback, and entertainment applications.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

let
  # VLC wrapper to prevent Wayland black screen on fullscreen transitions.
  # Forces XCB (XWayland) and OpenGL video output, which eliminates black screen
  # flicker and subsurface rendering bugs on Wayland compositors.
  vlcFixed = pkgs.symlinkJoin {
    name = "vlc-fixed";
    paths = [ pkgs.vlc ];
    nativeBuildInputs = [ pkgs.makeWrapper ];
    postBuild = ''
      wrapProgram $out/bin/vlc \
        --set QT_QPA_PLATFORM xcb \
        --add-flags "--vout=gl,any"

      rm $out/share/applications/vlc.desktop
      substitute ${pkgs.vlc}/share/applications/vlc.desktop $out/share/applications/vlc.desktop \
        --replace-fail "${pkgs.vlc}/bin/vlc" "$out/bin/vlc"
    '';
  };
in
{
  # ── Controller & Gamepad udev Rules ────────────────────────────────────────
  # Plug-and-play permissions for USB & Bluetooth controllers (Xbox, PS, Switch)
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # ── Environment variables ──────────────────────────────────────────────────
  # Tell ani-cli to use VLC as default player
  environment.sessionVariables = {
    ANI_CLI_PLAYER = "vlc";
  };

  # ── Default MIME Applications ──────────────────────────────────────────────
  xdg.mime.defaultApplications = {
    "video/mp4" = "vlc.desktop";
    "video/x-matroska" = "vlc.desktop";
    "video/mkv" = "vlc.desktop";
    "video/webm" = "vlc.desktop";
    "video/avi" = "vlc.desktop";
    "video/quicktime" = "vlc.desktop";
    "video/x-msvideo" = "vlc.desktop";
    "video/x-flv" = "vlc.desktop";
    "video/mpeg" = "vlc.desktop";
    "video/ogg" = "vlc.desktop";
    "video/3gpp" = "vlc.desktop";
    "video/mp2t" = "vlc.desktop";
  };

  # ── Packages ───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    spotify                             # Music streaming client
    mgba                                # Modern, accurate Game Boy Advance (GBA) emulator
    vlcFixed                            # VLC media player (custom wrapped for smooth fullscreen)
    ani-cli                             # CLI anime browser and streamer
    ani-skip                            # Auto-skip anime openings & endings in mpv
    mov-cli                             # CLI movie, TV show, and anime streamer
  ];
}
