{...}: {
  xdg.configFile."noctalia/templates/niri.kdl".text = ''
    layout {
        focus-ring {
            active-color "{{colors.primary.default.hex}}"
            inactive-color "{{colors.surface.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }

        border {
            active-color "{{colors.primary.default.hex}}"
            inactive-color "{{colors.surface.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }

        tab-indicator {
            active-color "{{colors.primary.default.hex}}"
            inactive-color "{{colors.primary_container.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }

        insert-hint {
            color "{{colors.primary.default.hex}}80"
        }
    }

    recent-windows {
        highlight {
            active-color "{{colors.primary.default.hex}}"
            urgent-color "{{colors.error.default.hex}}"
        }
    }
  '';

  local.desktopShell.niri = {
    launcherBinding = ''Mod+D hotkey-overlay-title="Open Noctalia Launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }'';
    lockBinding = ''Super+Alt+L hotkey-overlay-title="Lock with Noctalia" { spawn "noctalia" "msg" "session" "lock"; }'';

    # Noctalia writes this file from the current wallpaper palette. Keeping the
    # include optional lets Niri start with its static fallbacks before the file
    # is generated; Niri watches it and reloads automatically once it appears.
    extraConfig = ''include optional=true "noctalia.kdl"'';
  };

  programs.noctalia = {
    # Unlike KineticWE, Niri does not launch Noctalia on its own.
    systemd.enable = true;

    # Keep this integration declarative instead of adding "niri" to the
    # mutable built-in template list maintained by Noctalia's settings UI.
    settings.theme.templates.user."niri-wallpaper" = {
      input_path = "$XDG_CONFIG_HOME/noctalia/templates/niri.kdl";
      output_path = "$XDG_CONFIG_HOME/niri/noctalia.kdl";
    };
  };
}
