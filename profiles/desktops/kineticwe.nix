{...}: {
  imports = [../../modules/sessions/kineticwe.nix];

  # Install the complete KDE Plasma desktop as the base environment. KineticWE
  # remains a separate SDDM session because it replaces KWin rather than acting
  # as a plugin that can be loaded by startplasma.
  services.desktopManager.plasma6.enable = true;

  # The upstream KineticWE launcher starts this target once KWin has exported
  # WAYLAND_DISPLAY.  Provide the target it expects so the standard graphical
  # session target (and all user units attached to it) actually comes up.
  systemd.user.targets.kineticwe-workspace = {
    description = "KineticWE Workspace";
    requires = ["graphical-session.target"];
    wants = ["xdg-desktop-autostart.target"];
    bindsTo = ["graphical-session.target"];
    before = [
      "graphical-session.target"
      "xdg-desktop-autostart.target"
    ];
    unitConfig.StopWhenUnneeded = true;
  };

  # KineticWE's upstream session launches Noctalia itself. Enabling a second
  # Home Manager Noctalia service would start two shell instances.
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  home-manager.users.suezhoo.imports = [../../home/wm/kineticwe];
}
