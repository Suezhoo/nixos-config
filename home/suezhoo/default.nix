{...}: {
  imports = [
    ./common.nix

    # The personal profile keeps both compositor sessions available.
    ../wm/niri

    # Keep the existing Hyprland session in the personal profile.
    ../wm/hypr

    # Personal desktop shell.
    ../shell/waybar
    ../shell/wofi
    ../shell/wallpaper
  ];
}
