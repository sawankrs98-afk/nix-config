# ── Programming Languages & Toolchains ───────────────────────────────────────
# Development environments for C/C++, Rust, Java, Python, and SQL.
# Includes compilers, LSP servers, linters, formatters, and build tools.
# Also configures nix-ld for running unpatched dynamically-linked binaries.
# ─────────────────────────────────────────────────────────────────────────────
{ pkgs, ... }:

{
  # ── Java (system-wide) ─────────────────────────────────────────────────
  # Enable system-wide Java and set JAVA_HOME automatically
  programs.java = {
    enable = true;
    package = pkgs.jdk; # OpenJDK 21 LTS
  };

  # ── nix-ld ─────────────────────────────────────────────────────────────
  # Run dynamically linked unpatched binaries (VS Code extensions, Mason,
  # pip wheels, cargo builds, etc.)
  programs.nix-ld = {
    enable = true;
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      openssl
      glibc
      libffi
      pkg-config
    ];
  };

  # ── Environment Variables ──────────────────────────────────────────────
  # C/Rust interop (bindgen, header search)
  environment.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  };

  # ── Packages ───────────────────────────────────────────────────────────
  environment.systemPackages = with pkgs; [

    # ── C / C++ & Clang ────────────────────────────────────────────────
    clang               # Clang compiler
    clang-tools         # clangd (LSP), clang-format, clang-tidy
    gcc                 # GNU Compiler Collection & libstdc++
    gdb                 # GNU Debugger
    lldb                # LLVM Debugger
    cmake               # Build tool
    ninja               # Fast build generator
    gnumake             # GNU Make
    pkg-config          # Library compilation helper
    bear                # Generates compile_commands.json for clangd
    valgrind            # Memory leak detector & profiler

    # ── C / C++ Development Libraries ──────────────────────────────────
    glibc.dev
    openssl
    openssl.dev
    zlib
    zlib.dev
    libffi

    # ── Rust ───────────────────────────────────────────────────────────
    rustc               # Rust compiler
    cargo               # Rust package manager
    rustfmt             # Rust code formatter
    clippy              # Rust linter
    rust-analyzer       # Rust Language Server (LSP)
    cargo-watch         # Auto-rebuild on file changes

    # ── Java ───────────────────────────────────────────────────────────
    jdk                 # OpenJDK runtime & compiler
    jdt-language-server # Eclipse JDT Language Server (LSP for Helix/Neovim)
    maven               # Apache Maven build tool
    gradle              # Gradle build tool

    # ── Python ─────────────────────────────────────────────────────────
    (python3.withPackages (ps: with ps; [
      pip
      virtualenv
      ipython
      pytest
      debugpy
      setuptools
      wheel
    ]))
    uv                  # Blazing-fast modern Python package & project manager
    ruff                # Fast Python linter & formatter
    pyright             # Static type checker & LSP

    # ── SQL ────────────────────────────────────────────────────────────
    sqls                # SQL Language Server (syntax errors, diagnostics, completions)
    sqlfluff            # SQL linter & formatter
  ];
}
