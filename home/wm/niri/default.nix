{pkgs, ...}: {
  # Niri itself
  imports = [
    ./niri.nix
  ];

  # Niri uses the GNOME portal for PipeWire screen capture and the GTK
  # portal for ordinary desktop integration such as file pickers.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
    ];

    config.niri = {
      default = ["gnome" "gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
    };
  };
}
