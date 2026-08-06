{inputs, ...}: {
  imports = [
    ./common.nix
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    systemd.enable = false;
  };
}
