{ config, pkgs, ... }:

{
  imports = [
	./hardware-configuration.nix
	../../modules/common.nix
  ];

  networking.hostName = "suezhoo-desktop";

  users.users.suezhoo = {
	isNormalUser = true;
	extraGroups = [ "wheel" ]; #sudo

  };

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # KDE Plasma desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "24.05";

}

