{...}: {
  imports = [../../modules/niri.nix];

  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  home-manager.users.suezhoo.imports = [
    ../../home/wm/niri
    ../../home/shell/noctalia
  ];
}
