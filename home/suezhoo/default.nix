{pkgs, ...}: {
  home.stateVersion = "24.05";

  # user only packages
  home.packages = with pkgs; [
  ];

  imports = [
    #  ../hyperland
    ../apps/codium.nix
    ../apps/kitty.nix
    ../dev/nix-tools.nix

    #plasma
    ../plasma
  ];

  #  (optional) small Quality of Life
  programs.git = {
    enable = true;
    userName = "Suezhoo";
    userEmail = "suezhoo@outlook.com";
    extraConfig.init.defaultBranch = "main";
  };
}
