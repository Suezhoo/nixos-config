{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/hyprland.nix
    ../../modules/qylock.nix
  ];

  networking.hostName = "sayonara";

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
    # Keep older .hm-backup files intact when Home Manager first takes over
    # additional desktop configuration files.
    backupFileExtension = "hm-backup-20260805";

    # Pass host and pkgs-unstable to HM modules
    extraSpecialArgs = {
      host = config.networking.hostName;
      desktopShell = "custom";

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.system;
        config.allowUnfree = true;
      };
    };
  };

  # Allow unfree (apps like steam etc)
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # SDDM login screen for the Wayland sessions.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # Niri
  services.displayManager.sessionPackages = [pkgs.niri];

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
