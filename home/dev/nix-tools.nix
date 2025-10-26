{ pkgs, ... }:
{
  home.packages = with pkgs; [
    nil        # Nix language server
    nixfmt     # or: alejandra
    ripgrep
    fd
    unzip
  ];
}
