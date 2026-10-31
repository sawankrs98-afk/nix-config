# ── User Account & Shell ─────────────────────────────────────────────
# Defines the primary user "kuro", configures the Fish shell,
# sets up the OpenSSH agent, and pins the NixOS state version.
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── User: kuro ──────────────────────────────────────────────────────
  users.users."kuro" = {
    isNormalUser = true;
    description = "Saksham";
    shell = pkgs.fish;
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # ── SSH Agent ───────────────────────────────────────────────────────
  # Disable GNOME's gcr ssh-agent to avoid conflicts with OpenSSH's.
  services.gnome.gcr-ssh-agent.enable = false;

  # Start the standard OpenSSH agent at boot and persist keys across
  # sessions with AddKeysToAgent.
  programs.ssh = {
    startAgent = true;
    extraConfig = ''
      Host *
        AddKeysToAgent yes
    '';
  };

  # ── Fish Shell ──────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      set fish_greeting # Disable default greeting
    '';
  };

  # ── State Version ──────────────────────────────────────────────────
  # DO NOT change — tracks the NixOS release at initial install for
  # backwards-compatible defaults in stateful services.
  system.stateVersion = "26.05";
}
