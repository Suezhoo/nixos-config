{
  config,
  lib,
  pkgs,
  inputs,
  homeProfile,
  desktopShell,
  ...
}: {
  imports =
    [
      ./hardware-configuration.nix
      ../../modules/common.nix
      ../../modules/niri.nix
      ../../modules/gpu/nvidia.nix
    ]
    ++ lib.optionals (desktopShell == "custom") [
      ../../modules/hyprland.nix
      ../../modules/qylock.nix
    ];

  networking.hostName = "sayo";

  # Services used by the integrated shell control centres.
  hardware.bluetooth.enable = desktopShell != "custom";
  services.upower.enable = desktopShell != "custom";
  services.power-profiles-daemon.enable = desktopShell != "custom";

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
    users.suezhoo = import homeProfile;
    # Keep older .hm-backup files intact when Home Manager first takes over
    # additional desktop configuration files.
    backupFileExtension = "hm-backup-20260805";

    # Pass host and pkgs-unstable to HM modules
    extraSpecialArgs = {
      host = config.networking.hostName;
      inherit inputs desktopShell;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };
    };
  };
  # Allow unfree (apps like steam etc)
  nixpkgs.config.allowUnfree = true;

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.enable = false;

  # SDDM login screen for Niri.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # SDDM starts before the user's Niri session, so it needs its own monitor
  # layout. Keep this in sync with home/wm/niri/niri.nix.
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xrandr}/bin/xrandr \
      --output DP-2 --mode 1920x1080 --pos 0x180 \
      --output DP-3 --primary --mode 2560x1440 --pos 1920x0 \
      --output DP-4 --mode 1920x1080 --pos 4480x180
  '';

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
