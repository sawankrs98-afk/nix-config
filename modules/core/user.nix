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

  # Disable GNOME's gcr ssh agent to prevent conflict with standard OpenSSH agent
  services.gnome.gcr-ssh-agent.enable = false;

  # Automatically start standard OpenSSH agent on boot and retain keys across sessions
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
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
