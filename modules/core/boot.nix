# ── Bootloader & Kernel ──────────────────────────────────────────────
# Configures the Limine EFI bootloader with native-resolution
# branding, a Windows chainload entry, and the latest Linux kernel.
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── Limine EFI Bootloader ──────────────────────────────────────────
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 5;

    # Crisp native framebuffer resolution (avoids pixelation)
    resolution = "1920x1200";

    style = {
      interface = {
        resolution = "1920x1200";
        branding = "NixOS";
        brandingColor = "7EBAE4";  # NixOS blue / cyan accent
        helpHidden = true;         # Hide keybind help bar at top
      };
    };

    # Windows Boot Manager — EFI chainload entry
    extraEntries = ''
      /Windows Boot Manager
        protocol: efi_chainload
        image_path: guid(668f461e-a5e5-4360-b328-8cc47b3edec6):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # ── Kernel ──────────────────────────────────────────────────────────
  # Track the latest stable mainline kernel for newest hardware support.
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
