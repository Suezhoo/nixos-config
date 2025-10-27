{
  description = "NixOS config for Suezhoo";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";

    # HM
    home-manager.url = "github:nix-community/home-manager/release-24.05";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Plasma manager
    plasma-manager.url = "github:nix-community/plasma-manager";

    # Make plasma-manager follow home-manager's nixpkgs version
    plasma-manager.inputs.nixpkgs.follows = "nixpkgs";
    plasma-manager.inputs.home-manager.follows = "home-manager";
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    plasma-manager,
    ...
  }: {
    nixosConfigurations = {
      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/desktop/configuration.nix

          # Integrate Home Manager  into NixOS
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.suezhoo = import ./home/suezhoo;
            # Backup
            home-manager.backupFileExtension = "hm-bak";
          }
        ];
      };

      sayonara = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/sayonara/configuration.nix

          # HM
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.suezhoo = import ./home/suezhoo;
            home-manager.sharedModules = [plasma-manager.homeModules.plasma-manager];
          }
        ];
      };
    };
  };
}
