{pkgs, ...}: {
  home.stateVersion = "25.05";

  # user only packages
  home.packages = with pkgs; [
    zed-editor
  ];

  imports = [
    ../apps/codium.nix
    ../apps/kitty.nix
    ../dev/nix-tools.nix
    ../plasma # plasma
    ../hypr # hyprland
  ];

  #  (optional) small Quality of Life
  programs.git = {
    enable = true;
    userName = "Suezhoo";
    userEmail = "suezhoo@outlook.com";
    extraConfig.init.defaultBranch = "main";
  };
}
