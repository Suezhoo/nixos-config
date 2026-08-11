{
  inputs,
  pkgs,
  ...
}: {
  # The HM module exposes the session launcher in the user environment. SDDM
  # registration remains the responsibility of modules/sessions/kineticwe.nix.
  imports = [inputs.kineticwe.homeModules.default];

  home.packages = with pkgs; [
    kdePackages.systemsettings
  ];

  programs.kineticwe = {
    enable = true;
    autostart = false;
  };
}
