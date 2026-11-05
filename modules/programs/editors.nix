# ── Editors ───────────────────────────────────────────────────────────────────
# Text editors and IDEs available system-wide.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    helix   # Modal terminal editor
    vscode
    zed-editor
  ];
}
