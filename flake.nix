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
    mkSayo = {
      homeProfile,
      desktopShell,
      desktopSession ? "niri",
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs homeProfile desktopShell desktopSession;
        };
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
        ];
      };
  in {
    nixosConfigurations = {
      # Desktop profiles. `sayo` remains an alias for the personal rice so
      # existing rebuild commands continue to work.
      sayo = mkSayo {
        homeProfile = ./home/suezhoo/noctalia.nix;
        desktopShell = "noctalia";
      };
      sayo-custom = mkSayo {
        homeProfile = ./home/suezhoo;
        desktopShell = "custom";
      };
      sayo-noctalia = mkSayo {
        homeProfile = ./home/suezhoo/noctalia.nix;
        desktopShell = "noctalia";
      };
      sayo-inir = mkSayo {
        homeProfile = ./home/suezhoo/inir.nix;
        desktopShell = "inir";
      };
      sayo-kineticwe = mkSayo {
        homeProfile = ./home/suezhoo/kineticwe.nix;
        desktopShell = "kineticwe";
        desktopSession = "kineticwe";
      };
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
