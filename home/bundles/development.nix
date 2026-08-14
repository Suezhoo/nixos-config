{pkgs, ...}: {
  # Globally useful compilers, runtimes, and project bootstrap tools. Keep
  # libraries and version-sensitive dependencies in each project's devShell.
  home.packages = with pkgs; [
    # Nix
    nixd # Nix language server with NixOS/Home Manager option completion.
    alejandra # Nix formatter.

    # JavaScript / TypeScript
    nodejs # Includes npm, npx, and Corepack.
    pnpm

    # Python
    python3
    uv # Environments, dependencies, tools, and Python version management.
    ruff

    # C / C++
    gcc
    clang-tools # Includes clangd and clang-format.
    cmake
    gnumake
    ninja
    pkg-config
    gdb

    # General development utilities
    jq
    just
    ripgrep
    fd
    unzip
    shellcheck
  ];
}
