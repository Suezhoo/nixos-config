{
  config,
  pkgs,
  lib,
  host,
  ...
}: {
  home.packages = [pkgs.nerd-fonts.jetbrains-mono];

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

        modules-left = ["custom/os" "hyprland/workspaces" "niri/workspaces" "niri/window"];
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

        "custom/os" = {
          exec = pkgs.writeShellScript "waybar-distro-icon" ''
            . /etc/os-release

            case "$ID" in
              nixos) icon="󱄅" ;;
              arch) icon="" ;;
              fedora) icon="" ;;
              ubuntu) icon="" ;;
              *) icon="" ;;
            esac

            ${pkgs.jq}/bin/jq -nc \
              --arg text "$icon" \
              --arg tooltip "''${PRETTY_NAME:-$ID}" \
              '{text: $text, tooltip: $tooltip}'
          '';
          interval = "once";
          return-type = "json";
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
