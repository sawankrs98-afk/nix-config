# ── Browsers ─────────────────────────────────────────────────────────────────
# Web browsers: Firefox (managed via programs module), Brave, Zen Browser,
# and Helium (from flake inputs).
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, inputs, ... }:

{
  # ── Firefox ──────────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Additional Browsers ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    brave                                                                  # Chromium-based privacy browser
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen Browser (flake input)
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default      # Helium browser (flake input)
  ];
}
