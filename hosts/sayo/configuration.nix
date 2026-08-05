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
    ../../modules/niri.nix
    ../../modules/qylock.nix
    ../../modules/gpu/nvidia.nix
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
    # Keep older .hm-backup files intact when Home Manager first takes over
    # additional desktop configuration files.
    backupFileExtension = "hm-backup-20260805";

    sharedModules = [
      inputs.plasma-manager.homeModules.plasma-manager
    ];

    # Pass host and pkgs-unstable to HM modules
    extraSpecialArgs = {
      host = config.networking.hostName;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.system;
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

  # KDE Plasma desktop
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  # SDDM starts before the user's Niri session, so it needs its own monitor
  # layout. Keep this in sync with home/wm/niri/niri.nix.
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xorg.xrandr}/bin/xrandr \
      --output DP-4 --mode 1920x1080 --pos 0x180 \
      --output DP-3 --primary --mode 2560x1440 --pos 1920x0 \
      --output DP-2 --mode 1920x1080 --pos 4480x180
  '';

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
