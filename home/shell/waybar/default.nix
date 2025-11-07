{
  config,
  pkgs,
  lib,
  host,
  ...
}: {
  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "bottom";
        "margin-top" = 10;
        "margin-left" = 10;
        "margin-right" = 10;
        position = "top";
        height = 32;

        modules-left = ["hyprland/workspaces" "niri/workspaces"];
        modules-center = ["custom/host"];
        modules-right = ["clock"];

        clock = {
          interval = 1;
          format = "{:%Y-%m-%d | %H:%M:%S}";
          tooltip = true;
          tooltip-format = "{:L%Y %m %d, %A}";
        };

        "custom/host" = {
          format = "${config.home.username}@${host}";
          tooltip = false;
        };
      };
    };

    # Reference the Waybar style file
    style = builtins.readFile ./waybar.css;
  };
}
