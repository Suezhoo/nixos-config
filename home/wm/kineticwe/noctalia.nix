{pkgs, ...}: let
  defaultWallpaper = ../../../assets/wallpapers/default.png;
in {
  programs.noctalia = {
    enable = true;

    # KineticWE starts Noctalia itself.
    systemd.enable = false;

    settings = {
      config_version = 12;

      # [bar.default]
      bar.default = {
        center = ["clock" "weather"];
        end = [
          "tray"
          "clipboard"
          "network"
          "bluetooth"
          "volume"
          "input_volume"
          "brightness"
          "battery"
          "control-center"
          "session"
        ];
        start = [
          "launcher"
          "notifications"
          "wallpaper"
          "workspaces"
          "spacer_2"
          "ram"
          "cpu"
        ];
        widget_spacing = 10;
      };

      # [widget]
      widget = {
        clock = {
          format = "{:%H:%M  ·  %a %d %b  ·}";
          tooltip_format = "{:%A · %d %B %Y · %H:%M:%S}";
        };

        input_volume = {
          show_label = false;
        };

        volume = {
          show_label = false;
        };

        keyboard_layout = {
          show_label = false;
        };

        ram = {
          scale = 0.9;
        };

        network = {
          show_label = false;
        };

        spacer_2 = {
          length = 40;
          type = "spacer";
        };

        spacer_3 = {
          type = "spacer";
        };

        tray = {
          hidden = ["Screen casting"];
        };
      };

      # [theme]
      theme = {
        source = "wallpaper";
        wallpaper_scheme = "vibrant";

        templates = {
          enable_builtin_templates = true;
          builtin_ids = [
            "kitty"
            "kcolorscheme"
            "gtk3"
            "gtk4"
          ];
        };
      };

      # Reapply the generated scheme only after Noctalia has finished updating
      # its palette and application templates. This updates kdeglobals and
      # notifies running KDE applications without a login-time command.
      hooks.colors_changed = [
        "${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark && ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme noctalia"
      ];

      # [wallpaper]
      wallpaper = {
        default = {
          path = "${defaultWallpaper}";
        };
        last = {path = "${defaultWallpaper}";};
        monitors = {
          DP-2 = {
            path = "${defaultWallpaper}";
          };
          DP-3 = {
            path = "${defaultWallpaper}";
          };
          DP-4 = {
            path = "${defaultWallpaper}";
          };
        };
      };

      # [location]
      location = {
        auto_locate = false;
        address = "Geraardsbergen, Belgium";
      };

      # [weather]
      weather = {
        enabled = true;
        refresh_minutes = 30;
        unit = "metric";
        show_condition = false;
        show_temperature = true;
      };
    };
  };
}
