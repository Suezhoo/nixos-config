{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/common.nix
    ../../modules/gpu/nvidia.nix
    ../../modules/users/suezhoo.nix
  ];

  networking.hostName = "moonine";

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    users.suezhoo.imports = [
      ../../home/users/suezhoo
      ./home.nix
    ];
    # Preserve files that Home Manager takes over without relying on a fixed
    # suffix that can collide on a later activation.
    backupCommand = pkgs.writeShellScript "home-manager-backup" ''
      target="$1"
      timestamp="$(${pkgs.coreutils}/bin/date +%Y%m%d-%H%M%S)"
      backup="$target.hm-backup-$timestamp"
      counter=1

      while [[ -e "$backup" ]]; do
        backup="$target.hm-backup-$timestamp-$counter"
        counter=$((counter + 1))
      done

      ${pkgs.coreutils}/bin/mv -- "$target" "$backup"
    '';

    # Pass the host and explicit stable/unstable package sets to HM modules.
    # `pkgs` itself follows the package set selected by the desktop profile.
    extraSpecialArgs = {
      host = config.networking.hostName;
      inherit inputs;

      pkgs-stable = import inputs.nixpkgs {
        system = pkgs.stdenv.hostPlatform.system;
        config.allowUnfree = true;
      };

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

  # SDDM login screen for the selected Wayland session.
  services.xserver.enable = true;
  services.displayManager.sddm.enable = true;

  # SDDM starts before the user's desktop session and needs its own monitor
  # layout. Keep this aligned with the compositor-specific monitor settings.
  services.xserver.displayManager.setupCommands = ''
    ${pkgs.xrandr}/bin/xrandr \
      --output DP-4 --mode 1920x1080 --pos 0x180 \
      --output DP-3 --primary --mode 2560x1440 --pos 1920x0 \
      --output DP-2 --mode 1920x1080 --pos 4480x180
  '';

  # Pin to installed NixOS release; dont bump casually.
  system.stateVersion = "25.05";
}
