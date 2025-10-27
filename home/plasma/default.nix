{pkgs, ...}: {
  imports = [
    ./keybinds.nix
    ./panels.nix
  ];

  programs.plasma = {
    enable = true;

    # Important: replace existing layout file with the one from nix
    overrideConfig = true;
  };
}
