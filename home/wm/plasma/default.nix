{pkgs, ...}: {
  programs.plasma = {
    enable = true;

    # Important: replace existing layout file with the one from nix
    overrideConfig = true;

    workspace = {
      theme = "breeze-dark";
      colorScheme = "BreezeDark";
    };
  };

  imports = [
    ./keybinds.nix
    ./panels.nix
  ];
}
