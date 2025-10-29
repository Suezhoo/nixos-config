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
  ];

  # Enable Electron apps for Wayland
  environment.sessionVariables = {
    # NIXOS_OZONE_WL = "1";
    GTK_USE_PORTAL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "auto";
  };
}
