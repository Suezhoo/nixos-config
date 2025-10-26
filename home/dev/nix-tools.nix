{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil        # Nix language server
    alejandra  # or: alejandra
    ripgrep
    fd
    unzip
  ];
}
