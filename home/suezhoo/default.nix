{...}: {
  # Compatibility entry point used by the `sayonara` VM. Physical-host
  # desktop stacks are composed explicitly under profiles/desktops instead.
  imports = [
    ./common.nix
    ../wm/hypr
    ../shell/custom
  ];
}
