{inputs, ...}: {
  imports = [
    ./common.nix
    inputs.inir.homeModules.default
  ];

  programs.inir = {
    enable = true;
    service.enable = false;
  };
}
