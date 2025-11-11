{
  description = "NixOS config for Suezhoo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";

    # HM
    home-manager.url = "github:nix-community/home-manager/release-25.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma manager
    plasma-manager.url = "github:nix-community/plasma-manager";

    # Make plasma-manager follow home-manager's nixpkgs version
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  }: {
    nixosConfigurations = {
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
    };
  };
}
