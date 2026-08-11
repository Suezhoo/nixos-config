{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/sessions/hyprland.nix
    ../../modules/qylock.nix
    ../../modules/users/suezhoo.nix
  ];

  networking.hostName = "sayonara";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.suezhoo.imports = [
      ../../home/users/suezhoo
      ../../home/wm/hypr
      ../../home/shell/custom
    ];
    # Keep older .hm-backup files intact when Home Manager first takes over
    # additional desktop configuration files.
    backupFileExtension = "hm-backup-20260805";

    # Pass host and pkgs-unstable to HM modules
    extraSpecialArgs = {
      host = config.networking.hostName;

      pkgs-unstable = import inputs.nixpkgs-unstable {
        system = pkgs.stdenv.hostPlatform.system;
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

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
