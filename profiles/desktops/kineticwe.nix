{...}: {
  imports = [../../modules/sessions/kineticwe.nix];

  # KineticWE's upstream session currently bundles Noctalia, so keep this
  # desktop stack atomic until upstream exposes a compositor-only session.
  hardware.bluetooth.enable = true;
  services.upower.enable = true;
  services.power-profiles-daemon.enable = true;

  home-manager.users.suezhoo.imports = [../../home/wm/kineticwe];
}
