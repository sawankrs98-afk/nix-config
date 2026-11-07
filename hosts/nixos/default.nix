# ── Host: nixos ──────────────────────────────────────────────────────
# Machine-specific entry point.  Pulls in hardware config and all
# shared module bundles (core, desktops, programs), then adds any
# host-only tweaks.
# ─────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── Module Imports ──────────────────────────────────────────────────
  imports = [
    ./hardware-configuration.nix
    ../../modules/core
    ../../modules/desktops
    ../../modules/programs
  ];

  # ── Battery Health ──────────────────────────────────────────────────
  # Automatically cap battery charge at 80 % on boot / plug-in to
  # extend long-term battery lifespan.
  services.udev.extraRules = ''
    ACTION=="add|change", SUBSYSTEM=="power_supply", KERNEL=="BAT[0-9]", ATTR{charge_control_end_threshold}=="*", ATTR{charge_control_end_threshold}="80"
  '';

  # ── Database Service (MariaDB / MySQL) ──────────────────────────────
  services.mysql = {
    enable = true;
    package = pkgs.mariadb;
    ensureDatabases = [ "hospital_bed_db" ];
    ensureUsers = [
      {
        name = "root";
        ensurePermissions = {
          "hospital_bed_db.*" = "ALL PRIVILEGES";
        };
      }
    ];
    initialScript = pkgs.writeText "mariadb-init.sql" ''
      ALTER USER 'root'@'localhost' IDENTIFIED VIA mysql_native_password USING PASSWORD('root');
      CREATE USER IF NOT EXISTS 'root'@'127.0.0.1' IDENTIFIED VIA mysql_native_password USING PASSWORD('root');
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' WITH GRANT OPTION;
      GRANT ALL PRIVILEGES ON *.* TO 'root'@'127.0.0.1' WITH GRANT OPTION;
      FLUSH PRIVILEGES;
    '';
  };
}
