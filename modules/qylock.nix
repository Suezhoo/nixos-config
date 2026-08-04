{inputs, ...}: {
  imports = [
    inputs.qylock.nixosModules.default
  ];

  programs.qylock = {
    enable = true;
    theme = "field";
  };

  services.displayManager.sddm.wayland.enable = true;
}
