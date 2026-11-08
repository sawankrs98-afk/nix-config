{ lib, pkgs, inirBase }:

let
  inirHub = pkgs.fetchFromGitHub {
    owner = "snowarch";
    repo = "inir-hub";
    rev = "48ae8d87d73986209c63e2d0dbcdf2a2d2a02791";
    sha256 = "sha256-nCtkcqZI3x3TmtWRoSeoQNUdIypZw/r839WB6wcMVeA=";
  };

  inirAccelTar = pkgs.fetchurl {
    url = "https://github.com/snowarch/inir-accel/releases/download/v0.1.0/inir-accel-0.1.0-x86_64.tar.gz";
    sha256 = "sha256-8yXXfQwca+4gixYyFXjkon53bleFxCtg6QH9nDA99gM=";
  };

  inirAccel = pkgs.stdenv.mkDerivation {
    pname = "inir-accel";
    version = "0.1.0";
    src = inirAccelTar;
    nativeBuildInputs = [ pkgs.autoPatchelfHook ];
    buildInputs = [ pkgs.stdenv.cc.cc.lib ];
    sourceRoot = "inir-accel-0.1.0-x86_64";
    installPhase = ''
      mkdir -p $out/bin
      cp inir-accel $out/bin/inir-accel
      chmod +x $out/bin/inir-accel
    '';
  };
in
pkgs.stdenvNoCC.mkDerivation {
  pname = "inir-complete";
  version = inirBase.version or "2.33.0";

  nativeBuildInputs = [ pkgs.makeWrapper ];

  dontUnpack = true;

  installPhase = ''
    mkdir -p $out/share/quickshell/inir
    cp -r --no-preserve=mode,ownership ${inirBase}/share/quickshell/inir/. $out/share/quickshell/inir/

    # Copy families, components and designs from inir-hub
    mkdir -p $out/share/quickshell/inir/modules
    cp -r --no-preserve=mode,ownership ${inirHub}/families/. $out/share/quickshell/inir/modules/
    cp -r --no-preserve=mode,ownership ${inirHub}/components/. $out/share/quickshell/inir/modules/
    cp -r --no-preserve=mode,ownership ${inirHub}/designs/. $out/share/quickshell/inir/modules/

    # Ensure plugins.list has all installed families
    cat << 'EOF' > $out/share/quickshell/inir/plugins.list
ii
iris
waffle
fastfetch
airisu
EOF

    # Patch default niri keybinding for Mod+D so seeded setups use toggle-maximize
    if [ -f $out/share/quickshell/inir/defaults/niri/config.d/70-binds.kdl ]; then
      substituteInPlace $out/share/quickshell/inir/defaults/niri/config.d/70-binds.kdl \
        --replace-fail 'Mod+D { maximize-column; }' 'Mod+D { spawn "niri-toggle-maximize"; }'
    fi

    # Patch inir script to detect bundled inir-accel version if local accel link is absent
    substituteInPlace $out/share/quickshell/inir/scripts/inir \
      --replace-fail 'have="$(readlink "$data/accel/current" 2>/dev/null)"; have="''${have##*/}"' \
                     'have="$(readlink "$data/accel/current" 2>/dev/null)"; have="''${have##*/}"; [[ -z "$have" && -x "''${INIR_ACCEL:-}" ]] && have="$("$INIR_ACCEL" --version 2>/dev/null | head -n1 | cut -d" " -f2)"'

    # Fix GTK3 treeview/filechooser text color in generated GTK3 CSS
    if [ -f $out/share/quickshell/inir/scripts/colors/apply-gtk-theme.sh ]; then
      substituteInPlace $out/share/quickshell/inir/scripts/colors/apply-gtk-theme.sh \
        --replace-fail '.view {' 'treeview.view, .view, treeview, filechooser .view, filechooser treeview { color: ''${FG}; } .view {' \
        --replace-fail '@define-color accent_color' '@define-color theme_fg_color ''${FG};
@define-color theme_text_color ''${FG};
@define-color theme_bg_color ''${BG};
@define-color theme_base_color ''${BG};
@define-color theme_selected_bg_color ''${ROW_ACTIVE_BG};
@define-color theme_selected_fg_color ''${ROW_SELECTED_FG};

@define-color accent_color'
    fi

    # Ensure scripts remain executable after substitution
    chmod -R +x $out/share/quickshell/inir/scripts

    # Install inir-accel binary into the package
    mkdir -p $out/bin
    cp ${inirAccel}/bin/inir-accel $out/bin/inir-accel

    # Copy base inir binary and redirect its payload paths from inirBase to this package
    cp ${inirBase}/bin/inir $out/bin/.inir-wrapped
    chmod +w $out/bin/.inir-wrapped
    substituteInPlace $out/bin/.inir-wrapped \
      --replace-fail "${inirBase}" "$out"

    # Wrap the binary with INIR_ACCEL and runtime dirs
    makeWrapper $out/bin/.inir-wrapped $out/bin/inir \
      --set INIR_ACCEL "$out/bin/inir-accel" \
      --set INIR_SYSTEM_RUNTIME_DIR "$out/share/quickshell/inir" \
      --set INIR_FALLBACK_SYSTEM_RUNTIME_DIR "$out/share/quickshell/inir"
  '';

  meta = inirBase.meta or {};
}
