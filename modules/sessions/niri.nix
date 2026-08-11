{pkgs, ...}: {
  services.displayManager.sessionPackages = [pkgs.niri];

  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config.common.default = ["gnome"];
  };
}
