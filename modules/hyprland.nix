{pkgs, ...}: {
  # Hyperland Desktop
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };
}
