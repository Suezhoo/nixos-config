{inputs, ...}: {
  # Upstream owns the package overlay, display-manager session registration,
  # and KDE portal wiring. Keeping that integration here makes KineticWE a
  # replaceable system session rather than leaking it into the host module.
  imports = [inputs.kineticwe.nixosModules.default];

  programs.kineticwe.enable = true;
}
