{
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.stateVersion = "25.05";

  # user only packages
  home.packages = with pkgs; [
    steam
    obsidian

    # unstable
    pkgs-unstable.spotify
    pkgs-unstable.codex
  ];

  imports = [
    # Apps
    ../apps/codium.nix
    ../apps/kitty.nix
    ../apps/vesktop.nix
    ../apps/obs.nix
    ../apps/zed.nix

    # Dev things
    ../dev/nix-tools.nix

    # window manager (wm)
    ../wm/hypr
    ../wm/niri

    # Shell
    ../shell/waybar
    ../shell/wofi
    ../shell/wallpaper

    # Nvidia
    ../desktop/nvidia-session.nix
  ];

  # GTK applications need both a concrete theme and the desktop-wide
  # color-scheme hint. The latter is also exposed to sandboxed/Electron apps
  # through xdg-desktop-portal.
  gtk = {
    enable = true;
    theme = {
      name = "Adwaita-dark";
      package = pkgs.gnome-themes-extra;
    };

    gtk3.extraConfig.gtk-application-prefer-dark-theme = true;
    gtk4.extraConfig.gtk-application-prefer-dark-theme = true;
  };

  dconf.settings."org/gnome/desktop/interface" = {
    color-scheme = "prefer-dark";
    gtk-theme = "Adwaita-dark";
  };

  #  (optional) small Quality of Life
  programs.git = {
    enable = true;
    userName = "Suezhoo";
    userEmail = "suezhoo@outlook.com";
    extraConfig.init.defaultBranch = "main";
  };
}
