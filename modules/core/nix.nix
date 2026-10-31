# ── Nix Daemon Settings ──────────────────────────────────────────────
# Permits unfree packages (e.g. NVIDIA drivers, VS Code) and enables
# the modern Nix CLI + Flakes experimental features.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── Unfree Packages ─────────────────────────────────────────────────
  # Required for proprietary software from nixpkgs.
  nixpkgs.config.allowUnfree = true;

  # ── Experimental Features ───────────────────────────────────────────
  # nix-command  — new `nix build`, `nix develop`, etc. CLI
  # flakes       — reproducible, composable package inputs
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
