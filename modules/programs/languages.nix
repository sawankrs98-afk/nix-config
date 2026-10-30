{ pkgs, ... }:

{
  # Enable system-wide Java and set JAVA_HOME automatically
  programs.java = {
    enable = true;
    package = pkgs.jdk; # OpenJDK 21 LTS
  };

  # Enable nix-ld to run dynamically linked unpatched binaries (VS Code extensions, Mason, pip wheels, cargo)
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

  # Set environment variables for C/Rust interop (bindgen, header search)
  environment.sessionVariables = {
    LIBCLANG_PATH = "${pkgs.llvmPackages.libclang.lib}/lib";
  };

  environment.systemPackages = with pkgs; [
    # --- C / C++ & Clang ---
    clang
    clang-tools     # clangd (LSP), clang-format, clang-tidy
    gcc             # GNU Compiler Collection & libstdc++
    gdb             # GNU Debugger
    lldb            # LLVM Debugger
    cmake           # Build tool
    ninja           # Fast build generator
    gnumake         # GNU Make
    pkg-config      # Library compilation helper
    bear            # Generates compile_commands.json for clangd
    valgrind        # Memory leak detector & profiler

    # --- C / C++ Development Libraries ---
    glibc.dev
    openssl
    openssl.dev
    zlib
    zlib.dev
    libffi

    # --- Rust ---
    rustc           # Rust compiler
    cargo           # Rust package manager
    rustfmt         # Rust code formatter
    clippy          # Rust linter
    rust-analyzer   # Rust Language Server (LSP)
    cargo-watch     # Auto-rebuild on file changes

    # --- Java ---
    jdk             # OpenJDK runtime & compiler
    maven           # Apache Maven build tool
    gradle          # Gradle build tool

    # --- Python ---
    (python3.withPackages (ps: with ps; [
      pip
      virtualenv
      ipython
      pytest
      debugpy
      setuptools
      wheel
    ]))
    uv              # Blazing-fast modern Python package & project manager
    ruff            # Fast Python linter & formatter
    pyright         # Static type checker & LSP
  ];
}
