# ── Bluetooth ────────────────────────────────────────────────────────
# Enables the BlueZ Bluetooth stack and powers on the adapter at boot
# so wireless peripherals connect automatically.
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;  # Adapter is powered on immediately at startup
  };
}
