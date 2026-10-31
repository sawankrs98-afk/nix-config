# ── Audio ────────────────────────────────────────────────────────────
# Configures the PipeWire-based sound stack with PulseAudio and ALSA
# compatibility layers (including 32-bit support for Steam / Wine).
# ─────────────────────────────────────────────────────────────────────
{ ... }:

{
  # ── PulseAudio ──────────────────────────────────────────────────────
  # Disabled — PipeWire's pulse module takes its place.
  services.pulseaudio.enable = false;

  # ── Realtime Scheduling ────────────────────────────────────────────
  # rtkit grants PipeWire realtime priority for glitch-free playback.
  security.rtkit.enable = true;

  # ── PipeWire ────────────────────────────────────────────────────────
  services.pipewire = {
    enable = true;
    alsa.enable = true;          # ALSA compatibility
    alsa.support32Bit = true;    # 32-bit ALSA (Wine / Steam)
    pulse.enable = true;         # PulseAudio compatibility
  };
}
