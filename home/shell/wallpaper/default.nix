{pkgs, ...}: {
  home.packages = with pkgs; [
    waypaper # GUI for managing wallpapers
    swww # Backend daemon that visualizes the wallpaper
  ];

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    backend = swww
    fill = fill
    sort = name
    folder = ~/Pictures/wallpapers
    show_all = True
    restore_last = True
    language = en
  '';

  # Autostart wallpaper daemon and restore last wallpaper
  wayland.windowManager.hyprland.settings.exec-once = [
    "swww init"
    "waypaper --restore"
  ];
}
