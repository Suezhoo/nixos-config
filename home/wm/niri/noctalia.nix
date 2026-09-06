{pkgs, ...}: {
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
    launcherBinding = ''Mod+Space hotkey-overlay-title="Open Noctalia Launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }'';
    lockBinding = ''Super+Alt+L hotkey-overlay-title="Lock with Noctalia" { spawn "noctalia" "msg" "session" "lock"; }'';

    # Noctalia writes this file from the current wallpaper palette. Keeping the
    # include optional lets Niri start with its static fallbacks before the file
    # is generated; Niri watches it and reloads automatically once it appears.
    extraConfig = ''include optional=true "noctalia.kdl"'';
  };

  programs.noctalia = {
    # Unlike KineticWE, Niri does not launch Noctalia on its own.
    systemd.enable = true;

    settings = {
      # Reload applications after their generated palette files have changed.
      # USR1 makes every running Kitty process reread kitty.conf, including the
      # Noctalia include.  Toggling the KDE scheme is necessary because KDE's
      # helper otherwise treats an already-selected scheme as unchanged.
      hooks.colors_changed = [
        ''${pkgs.kitty}/bin/kitty +runpy "from kitty.utils import reload_conf_in_all_kitties; reload_conf_in_all_kitties()" || ${pkgs.procps}/bin/pkill -USR1 -x kitty || true''
        "${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark && ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme noctalia"
      ];

      # Keep this integration declarative instead of adding "niri" to the
      # mutable built-in template list maintained by Noctalia's settings UI.
      theme.templates.user."niri-wallpaper" = {
        input_path = "$XDG_CONFIG_HOME/noctalia/templates/niri.kdl";
        output_path = "$XDG_CONFIG_HOME/niri/noctalia.kdl";
      };
    };
  };

  # Outside Plasma, Qt cannot infer which desktop palette provider to use.
  # The KDE platform theme reads kdeglobals and responds to the change signal
  # emitted by plasma-apply-colorscheme, which keeps Dolphin in sync live.
  home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  home.packages = [
    pkgs.kdePackages.plasma-integration

    # Dolphin's Nix wrapper only exposes plugins from its own build closure;
    # merely installing plasma-integration does not add its platform theme to
    # QT_PLUGIN_PATH.  Shadow the system `dolphin` command in the user profile
    # so desktop-file, MIME, terminal, and Noctalia launches all see it.
    (pkgs.writeShellScriptBin "dolphin" ''
      export QT_QPA_PLATFORMTHEME=kde
      export QT_PLUGIN_PATH="${pkgs.kdePackages.plasma-integration}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
      exec ${pkgs.kdePackages.dolphin}/bin/dolphin "$@"
    '')
  ];

  # Noctalia starts launcher applications as its own descendants.  Home
  # Manager restarts this unit when its generated configuration changes; the
  # default control-group kill mode would also terminate Brave, Dolphin, and
  # every other application launched from the shell during each rebuild.
  systemd.user.services.noctalia.Service.KillMode = "process";
}
