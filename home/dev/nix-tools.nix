{pkgs, ...}: {
  home.packages = with pkgs; [
    nixd # Nix language server with NixOS/Home Manager option completion
    alejandra # Nix formatter
    ripgrep
    fd
    unzip
  ];
}
