{
  config,
  pkgs,
  host,
  ...
}: let
  powerMenu = pkgs.writeShellApplication {
    name = "waybar-power-menu";
    runtimeInputs = [pkgs.systemd pkgs.wofi];
    text = ''
      action="$(${pkgs.wofi}/bin/wofi \
        --dmenu \
        --prompt "Power" \
        <<< $'Lock\nLog out\nReboot\nShut down')"

      [[ -n "$action" ]] || exit 0

      if [[ "$action" == "Lock" ]]; then
        exec qylock-lock
      fi

      confirmation="$(${pkgs.wofi}/bin/wofi \
        --dmenu \
        --prompt "$action?" \
        <<< $'Cancel\nConfirm')"

      [[ "$confirmation" == "Confirm" ]] || exit 0

      case "$action" in
        "Log out")
          if [[ -n "''${NIRI_SOCKET:-}" ]]; then
            exec niri msg action quit --skip-confirmation
          elif [[ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
            exec hyprctl dispatch exit
          else
            echo "waybar-power-menu: unsupported desktop session" >&2
            exit 1
          fi
          ;;
        "Reboot") exec systemctl reboot ;;
        "Shut down") exec systemctl poweroff ;;
      esac
    '';
  };

  workspaceVariants = [
    {
      #   name = "japanese";
      #   icons = {
      #     "1" = "いち";
      #     "2" = "に";
      #     "3" = "さん";
      #     "4" = "よん";
      #     default = "〇";
      #   };
      # }
      # {
      name = "korean";
      icons = {
        "1" = "하나";
        "2" = "둘";
        "3" = "셋";
        "4" = "넷";
        default = "〇";
      };
      # }
      # {
      #   name = "chinese";
      #   icons = {
      #     "1" = "一";
      #     "2" = "二";
      #     "3" = "三";
      #     "4" = "四";
      #     default = "〇";
      #   };
      # }
      # {
      #   name = "english";
      #   icons = {
      #     "1" = "1";
      #     "2" = "2";
      #     "3" = "3";
      #     "4" = "4";
      #     default = "0";
      #   };
    }
  ];

  workspaceModules = compositor:
    map (variant: "${compositor}/workspaces#${variant.name}") workspaceVariants;

  workspaceSettings = compositor:
    builtins.listToAttrs (map (variant: {
        name = "${compositor}/workspaces#${variant.name}";
        value = {
          format = "{icon}";
          format-icons = variant.icons;
        };
      })
      workspaceVariants);

  commonBar = {
    layer = "bottom";
    "margin-top" = 10;
    "margin-left" = 10;
    "margin-right" = 10;
    position = "top";

    modules-center = ["custom/host"];
    modules-right = ["custom/gpu" "pulseaudio" "network" "tray" "clock" "custom/power"];

    clock = {
      interval = 1;
      format = "{:%d %a • %H:%M}";
      tooltip = true;
      tooltip-format = "{:L%Y %m %d, %A, %H:%M:%S}";
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

    "custom/power" = {
      format = "";
      tooltip = true;
      tooltip-format = "Power menu";
      on-click = "${powerMenu}/bin/waybar-power-menu";
    };

    "custom/gpu" = {
      interval = 5;
      format = "{}";
      exec = "nvidia-smi --query-gpu=utilization.gpu,temperature.gpu --format=csv,noheader,nounits | awk -F, '{ printf \"GPU: %2d%% %2d°C\", $1, $2 }'";
      return-type = "plain-text";
      tooltip = false;
    };

    pulseaudio = {
      format = "{volume}% {icon}";
      tooltip = true;
    };

    network = {
      format-wifi = "{essid} {signalStrength}%";
      format-ethernet = "{ifname}";
      format-disconnected = "";
      tooltip = true;
    };

    tray.spacing = 8;
  };

  mkBar = compositor:
    commonBar
    // workspaceSettings compositor
    // {modules-left = ["custom/os"] ++ workspaceModules compositor;};

  # Keep the bar at the same proportion of each monitor's physical height:
  # 36 / 1080 = 48 / 1440 = 3.33%.
  outputBars = [
    {
      name = "side";
      output = ["DP-2" "DP-4"];
      height = 36;
    }
    {
      name = "main";
      output = "DP-3";
      height = 48;
    }
  ];

  mkBars = compositor:
    map (outputBar: (mkBar compositor) // outputBar) outputBars;

  json = pkgs.formats.json {};
  niriConfig = json.generate "waybar-config-niri.json" (mkBars "niri");
  hyprlandConfig = json.generate "waybar-config-hyprland.json" (mkBars "hyprland");

  waybarSession = pkgs.writeShellApplication {
    name = "waybar-session";
    runtimeInputs = [pkgs.waybar];
    text = ''
      if [[ -n "''${NIRI_SOCKET:-}" ]]; then
        config_file="${config.xdg.configHome}/waybar/config-niri"
      elif [[ -n "''${HYPRLAND_INSTANCE_SIGNATURE:-}" ]]; then
        config_file="${config.xdg.configHome}/waybar/config-hyprland"
      else
        echo "waybar-session: could not detect Niri or Hyprland" >&2
        exit 1
      fi

      exec waybar --config "$config_file"
    '';
  };
in {
  home.packages = with pkgs; [
    nerd-fonts.monaspace
    nerd-fonts.jetbrains-mono
    noto-fonts-cjk-sans
    waybarSession
  ];

  programs.waybar = {
    enable = true;
    style = builtins.readFile ./waybar.css;
  };

  xdg.configFile = {
    "waybar/config-niri".source = niriConfig;
    "waybar/config-hyprland".source = hyprlandConfig;
  };
}
