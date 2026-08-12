{pkgs, ...}: {
  # Configure one cursor theme consistently across Wayland, GTK, and XWayland
  # applications. Bibata includes distinct link, text, resize, and busy shapes.
  home.pointerCursor.enable = true;
  home.pointerCursor = {
    name = "Bibata-Modern-Ice";
    package = pkgs.bibata-cursors;
    size = 24;

    gtk.enable = true;
    x11.enable = true;
  };
}
