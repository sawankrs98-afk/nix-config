# ── Nix Daemon Settings ──────────────────────────────────────────────
# Permits unfree packages (e.g. NVIDIA drivers, VS Code) and enables
# the modern Nix CLI + Flakes experimental features.
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── Unfree Packages ─────────────────────────────────────────────────
  # Required for proprietary software from nixpkgs.
  nixpkgs.config.allowUnfree = true;

  # ── Experimental Features ───────────────────────────────────────────
  # nix-command  — new `nix build`, `nix develop`, etc. CLI
  # flakes       — reproducible, composable package inputs
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ── Automatic Storage Maintenance ───────────────────────────────────
  # Automatically deduplicate identical files in the Nix store via hardlinks
  nix.settings.auto-optimise-store = true;

  # Daily garbage collection keeping only the last 5 system generations
  systemd.services.nix-gc-keep-5 = {
    description = "Nix Garbage Collection (Keep Last 5 Generations)";
    serviceConfig.Type = "oneshot";
    script = ''
      ${pkgs.nix}/bin/nix-env --profile /nix/var/nix/profiles/system --delete-generations +5
      ${pkgs.nix}/bin/nix-collect-garbage
    '';
  };

  systemd.timers.nix-gc-keep-5 = {
    description = "Daily timer for Nix garbage collection";
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "daily";
      Persistent = true;
    };
  };
}
