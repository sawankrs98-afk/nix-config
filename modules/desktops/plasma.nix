{ pkgs, lib, ... }:

{
  # X11 / Display / Desktop services
  services.xserver.enable = true;

  # SDDM Display Manager with Wayland support
  services.displayManager.sddm = {
    enable = true;
    wayland.enable = true;
  };

  # Default session for display manager
  services.displayManager.defaultSession = "plasma";

  # Desktop Environments
  services.desktopManager.plasma6.enable = true;
  services.desktopManager.gnome.enable = true;

  # Resolve conflict between Plasma (ksshaskpass) and GNOME (seahorse)
  programs.ssh.askPassword = lib.mkForce "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";

  # Keyboard layout
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Printing disabled
  services.printing.enable = false;
}
