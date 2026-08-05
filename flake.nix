{
  description = "NixOS config for Suezhoo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    # SDDM and Quickshell lock-screen themes.
    qylock = {
      url = "github:Darkkal44/qylock";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };

    # HM
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    ...
  }: {
    nixosConfigurations = {
      # Desktop
      sayo = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        # Make flake inputs available inside hosts/{hostname}/configuration.nix
        specialArgs = {inherit inputs;};

        modules = [
          ./hosts/sayo/configuration.nix

          # HM
          home-manager.nixosModules.home-manager
        ];
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
