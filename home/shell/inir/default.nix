{inputs, ...}: {
  imports = [inputs.inir.homeModules.default];

  local.desktopShell.niri = {
    startup = ''spawn-at-startup "inir" "run" "--session"'';
    launcherBinding = ''Mod+D hotkey-overlay-title="Open iNiR Search" { spawn "inir" "ipc" "overlay" "toggle"; }'';
    lockBinding = ''Super+Alt+L hotkey-overlay-title="Lock with iNiR" { spawn "inir" "ipc" "lock" "activate"; }'';
  };

  programs.inir = {
    enable = true;
    service.enable = false;
  };
}
