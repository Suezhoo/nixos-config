{
  description = "NixOS config for Suezhoo";

  # Trust the binary cache used by the pinned CachyOS kernel release. Keeping
  # this on the root flake makes it available to nix build/rebuild commands.
  nixConfig = {
    extra-substituters = ["https://attic.xuyh0120.win/lantian"];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Prebuilt CachyOS-patched kernels for NixOS. Keep this input's own
    # nixpkgs pin so its kernel patches and binary cache stay in sync.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";

    # SDDM and Quickshell lock-screen themes.
    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # Complete desktop shells for the optional Niri profiles. Let both inputs
    # retain their own nixpkgs pins so their current Quickshell/Qt stacks stay
    # compatible with the shells while this system remains on NixOS 25.05.
    noctalia.url = "github:noctalia-dev/noctalia/cachix";
    inir.url = "github:snowarch/iNiR";

    # HM
    home-manager.url = "github:nix-community/home-manager/release-25.05";
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
    }:
      nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = {
          inherit inputs homeProfile desktopShell;
        };
        modules = [
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
