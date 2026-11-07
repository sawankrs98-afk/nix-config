# ── Browsers ─────────────────────────────────────────────────────────────────
# Web browsers: Firefox (managed via programs module), Brave (via Flatpak),
# Zen Browser, and Helium (from flake inputs).
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, inputs, ... }:

{
  # ── Firefox ──────────────────────────────────────────────────────────────
  programs.firefox.enable = true;

  # ── Additional Browsers ─────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.default # Zen Browser (flake input)
    inputs.helium.packages.${pkgs.stdenv.hostPlatform.system}.default      # Helium browser (flake input)
  ];

  # ── Flatpak & Brave Browser ──────────────────────────────────────────────
  services.flatpak.enable = true;

  # Automatically configure Flathub remote and declaratively install Brave Browser
  systemd.services.flatpak-install-brave = {
    description = "Ensure Flathub and Brave Browser Flatpak are installed";
    wantedBy = [ "multi-user.target" ];
    after = [ "network-online.target" ];
    wants = [ "network-online.target" ];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart = pkgs.writeShellScript "install-flathub-brave" ''
        ${pkgs.flatpak}/bin/flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
        ${pkgs.flatpak}/bin/flatpak install -y --noninteractive flathub com.brave.Browser || true
      '';
    };
  };
}
