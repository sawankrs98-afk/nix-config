# ── Media ─────────────────────────────────────────────────────────────────────
# Music and media playback applications.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    spotify # Music streaming client
  ];
}
