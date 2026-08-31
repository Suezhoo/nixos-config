# Shared default configuration for the Noctalia shell.
# Any window manager using Noctalia can import this module and add or override
# compositor-specific settings in its corresponding Home Manager module.
{inputs, ...}: let
  defaultWallpaper = ../../../assets/wallpapers/default.png;
in {
  imports = [inputs.noctalia.homeModules.default];

  programs.noctalia = {
    enable = true;

    settings = {
      config_version = 12;

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

      widget = {
        clock = {
          format = "{:%H:%M  ·  %a %d %b  ·}";
          tooltip_format = "{:%A · %d %B %Y · %H:%M:%S}";
        };
        input_volume.show_label = false;
        volume.show_label = false;
        keyboard_layout.show_label = false;
        ram.scale = 0.9;
        network.show_label = false;
        spacer_2 = {
          length = 40;
          type = "spacer";
        };
        spacer_3.type = "spacer";
        tray.hidden = ["Screen casting"];
      };

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

      wallpaper = {
        enabled = true;
        default.path = "${defaultWallpaper}";
      };

      location = {
        auto_locate = false;
        address = "Geraardsbergen, Belgium";
      };

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
