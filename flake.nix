{
  description = "NixOS config for Suezhoo";

  inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
 	
	# HM
	home-manager.url = "github:nix-community/home-manager/release-24.05";
	home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
  {
	nixosConfigurations.desktop = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  modules = [
		./hosts/desktop/configuration.nix

		# Integrate Home Manager  into NixOS
		home-manager.nixosModules.home-manager
		{
		  home-manager.useGlobalPkgs = true;
		  home-manager.useUserPackages = true;
		  home-manager.users.suezhoo = import ./home/suezhoo.nix;
		  # Backup
		  home-manager.backupFileExtension = "hm-bak";
		}
	   ];
	};
  };
}
