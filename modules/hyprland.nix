{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    hyprland #
  ];

  # Minimal waybar
  programs.waybar.enable = true;
}
