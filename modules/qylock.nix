{
  inputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.qylock.nixosModules.default
  ];

  programs.qylock = {
    enable = true;
    theme = "field";
  };

  services.displayManager.sddm = {
    # Qylock's SDDM themes use Qt 6 modules. Plasma used to select this SDDM
    # build implicitly; keep it explicit now that Plasma is not installed.
    package = pkgs.kdePackages.sddm;
    wayland.enable = true;
  };
}
