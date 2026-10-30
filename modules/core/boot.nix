{ pkgs, ... }:

{
  # Limine EFI bootloader
  boot.loader.limine = {
    enable = true;
    efiSupport = true;
    maxGenerations = 5;

    # Fix pixelation: set crisp native 1920x1200 resolution
    resolution = "1920x1200";

    style = {
      interface = {
        resolution = "1920x1200";
        branding = "NixOS";
        brandingColor = "7EBAE4"; # Clean NixOS blue/cyan accent
        helpHidden = true;        # Hides cluttered keybind help at the top
      };
    };

    # Windows Boot Manager EFI chainload entry
    extraEntries = ''
      /Windows Boot Manager
        protocol: efi_chainload
        image_path: guid(668f461e-a5e5-4360-b328-8cc47b3edec6):/EFI/Microsoft/Boot/bootmgfw.efi
    '';
  };

  boot.loader.efi.canTouchEfiVariables = true;

  # Latest Linux kernel
  boot.kernelPackages = pkgs.linuxPackages_latest;
}
