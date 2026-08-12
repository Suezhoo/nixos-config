{
  description = "NixOS config for Suezhoo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # CachyOS Kernel
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # SDDM and Quickshell lock-screen themes.
    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Complete desktop shells for the optional Niri profiles. Let both inputs
    # retain their own nixpkgs pins so their current Quickshell/Qt stacks stay
    # compatible with the shells while the base system remains on stable NixOS.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    inir.url = "github:snowarch/iNiR";

    # KWin-based tiling compositor/session. Keep its upstream nixpkgs pin:
    # KineticWE currently needs a newer Qt/KF stack than the stable system.
    kineticwe = {
      url = "gitlab:theblackdon/kineticwe";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # HM
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-unstable.url = "github:nix-community/home-manager";
    home-manager-unstable.inputs.nixpkgs.follows = "nixpkgs-unstable";

    # Declarative KDE Plasma settings for the KineticWE profile.
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
      inputs.home-manager.follows = "home-manager-unstable";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    home-manager-unstable,
    ...
  }: let
    mkMoonine = nixpkgsInput: homeManagerInput: desktopProfile:
      nixpkgsInput.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./modules/kernel/cachyos.nix
          ./hosts/moonine/configuration.nix
          homeManagerInput.nixosModules.home-manager
          desktopProfile
        ];
      };
  in {
    nixosConfigurations = {
      # Desktop stacks are explicit, known-good compositor/shell pairings.
      # `moonine` is an alias for the default KDE + KineticWE configuration.
      # KineticWE tracks the newer KDE/Qt stack from nixpkgs-unstable. Build
      # the complete Plasma environment from that same revision so KWin, its
      # KCMs, portals, and libkscreen all speak matching protocols.
      moonine = mkMoonine nixpkgs-unstable home-manager-unstable ./profiles/desktops/kineticwe.nix;
      moonine-kineticwe = mkMoonine nixpkgs-unstable home-manager-unstable ./profiles/desktops/kineticwe.nix;

      moonine-custom = mkMoonine nixpkgs home-manager ./profiles/desktops/niri-custom.nix;
      moonine-noctalia = mkMoonine nixpkgs home-manager ./profiles/desktops/niri-noctalia.nix;
      moonine-inir = mkMoonine nixpkgs home-manager ./profiles/desktops/niri-inir.nix;
      moonine-hyprland = mkMoonine nixpkgs home-manager ./profiles/desktops/hyprland-custom.nix;
    };
  };
}
