{...}: {
  imports = [
    ../../modules/hyprland.nix
    ../../modules/qylock.nix
  ];

  home-manager.users.suezhoo.imports = [
    ../../home/wm/hypr
    ../../home/shell/custom
  ];
}
