{pkgs, ...}: {
  home.stateVersion = "25.05";

  # user only packages
  home.packages = with pkgs; [
    zed-editor
    steam
    vesktop
    obsidian
    spotify
  ];

  imports = [
    # Apps
    ../apps/codium.nix
    ../apps/kitty.nix
    ../apps/vesktop.nix

    # Dev things
    ../dev/nix-tools.nix

    # window manager (wm)
    ../wm/plasma
    ../wm/hypr
    ../wm/niri

    # Shell
    ../shell/waybar
    ../shell/wofi
    ../shell/wallpaper
  ];

  #  (optional) small Quality of Life
  programs.git = {
    enable = true;
    userName = "Suezhoo";
    userEmail = "suezhoo@outlook.com";
    extraConfig.init.defaultBranch = "main";
  };
}
