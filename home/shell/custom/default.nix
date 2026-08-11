{...}: {
  imports = [
    ../waybar
    ../wofi
    ../wallpaper
  ];

  local.desktopShell.niri = {
    launcherBinding = ''Mod+D hotkey-overlay-title="Run an Application: wofi" { spawn "wofi" "--show" "drun"; }'';
    lockBinding = ''Super+Alt+L hotkey-overlay-title="Lock the Screen: qylock" { spawn "qylock-lock"; }'';
  };
}
