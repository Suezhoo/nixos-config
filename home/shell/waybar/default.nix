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
        position = "top";
        height = 32;
        modules-left = ["hyprland/workspaces"];
        modules-center = ["clock"];
        modules-right = ["cpu" "memory" "network"];

        network = {
          interval = 2;

          # show whats shown
          format = "Idk just a test";
          format-wifi = "{bandwithDownBytes}/s";
          format-ethernet = "{bandwithDownBytes}/s}";
          format-disconnected = "no net";

          tooltip-format = "{ifname} {bandwithDownBytes}/s {bandwithUpBytes}/s";

          # toggle alt display on click
          on-click = "waybar-msg module network format alt";
          format-alt = "{bandwithDownBytes} | {bandwithUpBytes}";
        };
      };
    };

    style = builtins.readFile ./waybar.css;
  };
}
