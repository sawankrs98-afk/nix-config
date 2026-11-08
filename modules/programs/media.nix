# ── Media & Entertainment ────────────────────────────────────────────────────
# Music streaming and gaming emulation applications.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── Controller & Gamepad udev Rules ────────────────────────────────────────
  # Plug-and-play permissions for USB & Bluetooth controllers (Xbox, PS, Switch)
  services.udev.packages = with pkgs; [
    game-devices-udev-rules
  ];

  # ── Packages ───────────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    spotify                             # Music streaming client
    mgba                                # Modern, accurate Game Boy Advance (GBA) emulator
    ani-cli                             # CLI anime browser and streamer
    ani-skip                            # Auto-skip anime openings & endings in mpv
    mov-cli                             # CLI movie, TV show, and anime streamer
  ];
}
