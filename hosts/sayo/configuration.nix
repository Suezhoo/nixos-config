{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  networking.hostName = "sayo";

  users.users.suezhoo = {
    isNormalUser = true;
    extraGroups = ["wheel"]; #sudo
  };

  # Allow unfree (apps like steam etc)
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  # KDE Plasma desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
