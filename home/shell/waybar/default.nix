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

        modules-left = ["hyprland/workspaces" "niri/workspaces" "niri/window"];
        modules-center = ["custom/host"];
        # 👇 add GPU info next to clock
        modules-right = ["custom/gpu" "pulseaudio" "clock" "network" "tray"];

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

        # 🧩 GPU usage + temp via nvidia-smi
        "custom/gpu" = {
          interval = 5; # refresh every 5 seconds
          format = "{}";
          exec = "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | awk -F, '{ printf \"GPU: %2d%% %2d°C\", $1, $2 }'";
          return-type = "plain-text";
          tooltip = false;
        };

        "pulseaudio" = {
          format = "{volume}% {icon}";
          tooltip = true;
        };

        "network" = {
          format-wifi = "{essid} {signalStrength}%";
          format-ethernet = "{ifname}";
          format-disconnected = "";
          tooltip = true;
        };

        "tray" = {spacing = 8;};
      };
    };

    # Reference the Waybar style file
    style = builtins.readFile ./waybar.css;
  };
}
