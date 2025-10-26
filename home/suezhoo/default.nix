{ pkgs, ...}: {
	home.stateVersion = "24.05";

	# user only packages
	home.packages = with pkgs; [
	];

	imports = [ ../apps/codium.nix ];

	#  (optional) small Quality of Life
	programs.git.enable = true;
}
