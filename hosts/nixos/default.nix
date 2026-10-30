{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops
    ../../modules/programs
  ];
}
