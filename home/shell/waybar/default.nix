{
  config,
  pkgs,
  lib,
  host,
  ...
}: {
  home.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
  ];

  programs.waybar = {
    enable = true;

    settings = {
      mainBar = {
        layer = "bottom";
        "margin-top" = 10;
        "margin-left" = 20;
        "margin-right" = 20;
        position = "top";
        height = 32;

        modules-left = [
          "custom/os"
          "niri/workspaces#japanese"
          "niri/workspaces#korean"
          "niri/workspaces#chinese"
          "niri/workspaces#english"
          "hyprland/workspaces#japanese"
          "hyprland/workspaces#korean"
          "hyprland/workspaces#chinese"
          "hyprland/workspaces#english"
        ];
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

        "niri/workspaces#japanese" = {
          format = "{icon}";
          format-icons = {
            "1" = "いち";
            "2" = "に";
            "3" = "さん";
            "4" = "よん";
            default = "〇";
          };
        };

        "niri/workspaces#korean" = {
          format = "{icon}";
          format-icons = {
            "1" = "하나";
            "2" = "둘";
            "3" = "셋";
            "4" = "넷";
            default = "〇";
          };
        };

        "niri/workspaces#chinese" = {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            default = "〇";
          };
        };

        "niri/workspaces#english" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            default = "0";
          };
        };

        "hyprland/workspaces#japanese" = {
          format = "{icon}";
          format-icons = {
            "1" = "いち";
            "2" = "に";
            "3" = "さん";
            "4" = "よん";
            default = "〇";
          };
        };

        "hyprland/workspaces#korean" = {
          format = "{icon}";
          format-icons = {
            "1" = "하나";
            "2" = "둘";
            "3" = "셋";
            "4" = "넷";
            default = "〇";
          };
        };

        "hyprland/workspaces#chinese" = {
          format = "{icon}";
          format-icons = {
            "1" = "一";
            "2" = "二";
            "3" = "三";
            "4" = "四";
            default = "〇";
          };
        };

        "hyprland/workspaces#english" = {
          format = "{icon}";
          format-icons = {
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            default = "0";
          };
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
