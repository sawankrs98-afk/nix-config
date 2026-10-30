{ pkgs, ... }:

{
  # User account configuration
  users.users."kuro" = {
    isNormalUser = true;
    description = "Saksham";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Fish shell configuration
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable default greeting
    '';
  };

  # NixOS state version
  system.stateVersion = "26.05";
}
