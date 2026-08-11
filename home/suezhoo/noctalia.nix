{inputs, ...}: {
  imports = [
    ./common.nix
    ../wm/niri
    inputs.noctalia.homeModules.default
  ];

  programs.noctalia = {
    enable = true;
    # Let Home Manager own the shell process.  This makes profile switches
    # stop Noctalia when its unit disappears instead of leaving the directly
    # spawned process alive in the current Niri session.
    systemd.enable = true;

    settings = {
      theme = {
        mode = "dark";
        source = "builtin";
        builtin = "Catppuccin";
      };

      wallpaper = {
        enabled = true;
        default.path = "/";
      };
    };
  };
}
