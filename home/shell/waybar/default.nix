{
  config,
  pkgs,
  ...
}: {
  programs.waybar = {
    enable = true;
    settings = {
      mainBar = {
        layer = "bottom";
        margin-top = 10;
        margin-left = 10;
        margin-right = 10;
        position = "top";
        height = 32;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["hyprland/window"];
        modules-right = ["clock"];

        clock = {
          interval = 1;
          format = "{:%Y-%m-%d | %H:%M:%S}";
          tooltip = true;
          tooltip-format = "{:L%Y %m %d, %A}";
        };
      };
    };

    style = builtins.readFile ./waybar.css;
  };
}
