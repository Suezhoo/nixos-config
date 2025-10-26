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
    kitty
    kitty-themes
  ];
}
