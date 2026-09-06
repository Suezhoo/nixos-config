{...}: {
  imports = [
    ../../modules/sessions/hyprland.nix
    ../../modules/qylock.nix
  ];

  # Noctalia's hardware-backed widgets need the same system services in both
  # the Niri and Hyprland sessions.
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  home-manager.users.suezhoo.imports = [
    ../../home/wm/hypr
    ../../home/wm/hypr/noctalia.nix
    ../../home/shell/noctalia
  ];
}
