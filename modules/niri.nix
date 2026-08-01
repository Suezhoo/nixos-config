{pkgs, ...}: {
  # Make Niri available as a display-manager session.
  services.displayManager.sessionPackages = [pkgs.niri];

  # Niri delegates screen/window capture to the GNOME portal. This must be in
  # the system portal profile because that profile takes precedence over Home
  # Manager's portal backend directory.
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common.default = ["gnome"];
    };
  };
}
