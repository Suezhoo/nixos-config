{inputs, ...}: {
  # Upstream owns its overlay, SDDM session registration, and KDE portals.
  imports = [inputs.kineticwe.nixosModules.default];
  programs.kineticwe.enable = true;
}
