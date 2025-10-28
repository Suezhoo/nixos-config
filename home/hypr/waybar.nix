{ config, pkgs, ...}:

{
	programs.waybar = {
	enable = true;
	settings = {
		mainBar = {
			layer ="top";
			position ="top";
			height = 32;
			modules-left=["hyprland/workspaces" "clock"];
			modules-right=["cpu" "memory" "network" "battery" "tray"];
		};
	};

	style = ''
		*{
			font-family: JetBrainsMono, sans-serif;
			font-size: 12px;
		}
		window#waybar {
			background: rgba(30,30,30,0.8);
			border-radius: 8px;
		}
		'';
	};
}
