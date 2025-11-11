{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
  ];

  networking.hostName = "sayo";

  # define the user
  users.groups.Suezhoo = {};
  users.users.suezhoo = {
    isNormalUser = true;
    group = "Suezhoo";
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input"];
  };

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.suezhoo = import ../../home/suezhoo;
    backupFileExtension = "hm-backup";

    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    # Pass host to HM modules
    extraSpecialArgs = {
      host = config.networking.hostName;
    };
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

  # Niri
  services.displayManager.sessionPackages = [pkgs.niri];

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
