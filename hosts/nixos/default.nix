{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops
    ../../modules/programs
  ];

  # Automatically cap battery charge at 80% on boot/plug-in
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="BAT[0-9]", ATTR{charge_control_end_threshold}=="*", ATTR{charge_control_end_threshold}="80"
  '';
}
