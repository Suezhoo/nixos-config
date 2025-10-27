{ ... }:
{
	imports = [
	../../modules/common.nix
	./hardware-configuration.nix
	];

	networking.hostname = "sayonara";
}
