{...}: {
  imports = [
    ../../modules/niri.nix
    ../../modules/qylock.nix
  ];

  home-manager.users.suezhoo.imports = [
    ../../home/wm/niri
    ../../home/shell/custom
  ];
}
