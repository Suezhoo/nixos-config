{
  config,
  pkgs,
  host,
  ...
}: let
  workspaceVariants = [
    {
      name = "japanese";
      icons = {
        "1" = "いち";
        "2" = "に";
        "3" = "さん";
        "4" = "よん";
        default = "〇";
      };
    }
    {
      name = "korean";
      icons = {
        "1" = "하나";
        "2" = "둘";
        "3" = "셋";
        "4" = "넷";
        default = "〇";
      };
    }
    {
      name = "chinese";
      icons = {
        "1" = "一";
        "2" = "二";
        "3" = "三";
        "4" = "四";
        default = "〇";
      };
    }
    {
      name = "english";
      icons = {
        "1" = "1";
        "2" = "2";
        "3" = "3";
        "4" = "4";
        default = "0";
      };
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
    "margin-left" = 20;
    "margin-right" = 20;
    position = "top";
    height = 32;

    modules-center = ["custom/host"];
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

  json = pkgs.formats.json {};
  niriConfig = json.generate "waybar-config-niri.json" [(mkBar "niri")];
  hyprlandConfig = json.generate "waybar-config-hyprland.json" [(mkBar "hyprland")];

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
