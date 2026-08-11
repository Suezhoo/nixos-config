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
    mkSayo = desktopProfile:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {inherit inputs;};
        modules = [
          # cachyos kernel
          (
            {pkgs, ...}: {
              nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

              boot.kernelPackages = pkgs.cachyosKernels.linuxPackages-cachyos-latest;
            }
          )

          # other configs
          ./hosts/sayo/configuration.nix
          home-manager.nixosModules.home-manager
          desktopProfile
        ];
      };
  in {
    nixosConfigurations = {
      # Desktop stacks are explicit, known-good compositor/shell pairings.
      # `sayo` remains an alias for Niri + Noctalia so existing commands work.
      sayo = mkSayo ./profiles/desktops/niri-noctalia.nix;
      sayo-custom = mkSayo ./profiles/desktops/niri-custom.nix;
      sayo-noctalia = mkSayo ./profiles/desktops/niri-noctalia.nix;
      sayo-inir = mkSayo ./profiles/desktops/niri-inir.nix;
      sayo-kineticwe = mkSayo ./profiles/desktops/kineticwe.nix;
      sayo-hyprland = mkSayo ./profiles/desktops/hyprland-custom.nix;
      # VM
      sayonara = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Make flake inputs available inside hosts/{hostname}/configuration.nix
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/sayonara/configuration.nix

          # HM
          home-manager.nixosModules.home-manager
        ];
      };
    };
  };
}
