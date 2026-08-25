{pkgs, ...}: {
  # Configure one cursor theme consistently across Wayland, GTK, and XWayland
  # applications.
  home.pointerCursor = {
    enable = true;
    name = "Breeze_Light";
    package = pkgs.kdePackages.breeze;
    size = 20;

    gtk.enable = true;
    x11.enable = true;
  };
}
