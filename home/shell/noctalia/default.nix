{inputs, ...}: {
  imports = [inputs.noctalia.homeModules.default];

  local.desktopShell.niri = {
    launcherBinding = ''Mod+D hotkey-overlay-title="Open Noctalia Launcher" { spawn "noctalia" "msg" "panel-toggle" "launcher"; }'';
    lockBinding = ''Super+Alt+L hotkey-overlay-title="Lock with Noctalia" { spawn "noctalia" "msg" "session" "lock"; }'';
  };

  programs.noctalia = {
    enable = true;
    systemd.enable = true;
    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };
      wallpaper = {
        enabled = true;
        default.path = "/";
      };
    };
  };
}
