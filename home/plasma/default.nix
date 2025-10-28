{pkgs, ...}: {
  programs.plasma = {
    enable = true;

    # Important: replace existing layout file with the one from nix
    overrideConfig = true;
  };

  imports = [
    ./keybinds.nix
    ./panels.nix
  ];
}
