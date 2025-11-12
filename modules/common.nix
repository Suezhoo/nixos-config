{pkgs, ...}: {
  # Enable modern CLI + flakes permanently
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Basics
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Handy tools
  environment.systemPackages = with pkgs; [
    git
    gh
    vim
    neovim
    wget
    curl
    brave
    firefox
    kitty
    kitty-themes
    foot
    fastfetch
    zed-editor

    pavucontrol # audio
  ];

  # Enable Electron apps for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # enable Wayland for Electron apps by default
    GTK_USE_PORTAL = "1"; # good to keep for file dialogs/screenshare
  };
}
