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
    kineticwe.url = "gitlab:theblackdon/kineticwe";

    # HM
    home-manager.url = "github:nix-community/home-manager/release-26.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: let
    mkMoonine = desktopProfile:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          ./modules/kernel/cachyos.nix
          ./hosts/moonine/configuration.nix
          home-manager.nixosModules.home-manager
          desktopProfile
        ];
      };
  in {
    nixosConfigurations = {
      # Desktop stacks are explicit, known-good compositor/shell pairings.
      # `moonine` is the default Niri + Noctalia configuration.
      moonine = mkMoonine ./profiles/desktops/niri-noctalia.nix;
      moonine-custom = mkMoonine ./profiles/desktops/niri-custom.nix;
      moonine-noctalia = mkMoonine ./profiles/desktops/niri-noctalia.nix;
      moonine-inir = mkMoonine ./profiles/desktops/niri-inir.nix;
      moonine-kineticwe = mkMoonine ./profiles/desktops/kineticwe.nix;
      moonine-hyprland = mkMoonine ./profiles/desktops/hyprland-custom.nix;
    };
  };
}
