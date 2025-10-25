{
  description = "NixOS config for suezhoo-desktop";

  inputs = {
	nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
  };

  outputs = { self, nixpkgs, ... }:
  {
	nixosConfigurations.suezhoo-desktop = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  modules = [
		./hosts/suezhoo-desktop/configuration.nix
	  ];
	};
  };
}
