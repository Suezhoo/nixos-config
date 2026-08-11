{inputs, ...}: {
  imports = [
    ./common.nix
    ../wm/niri
    inputs.inir.homeModules.default
  ];

  programs.inir = {
    enable = true;
    service.enable = false;
  };
}
