{pkgs, ...}: {
  # Niri itself
  imports = [
    ./niri.nix
  ];

  # Keep application-specific behavior separate from the main compositor
  # configuration so window rules remain easy to scan and extend.
  xdg.configFile."niri/window-rules.kdl".source = ./window-rules.kdl;

  # Niri uses the GNOME portal for PipeWire screen capture and the GTK
  # portal for ordinary desktop integration such as file pickers.
  xdg.portal = {
    enable = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal-gnome
      xdg-desktop-portal-gtk
    ];

    config.niri = {
      default = ["gnome" "gtk"];
      "org.freedesktop.impl.portal.ScreenCast" = "gnome";
      "org.freedesktop.impl.portal.RemoteDesktop" = "gnome";
      "org.freedesktop.impl.portal.FileChooser" = "gtk";
      "org.freedesktop.impl.portal.Screenshot" = "gtk";
    };
  };
}
