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

  # Start the swww daemon for this user session
  systemd.user.services.swww = {
    Unit = {
      Description = "swww wallpaper daemon";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  # Restore the last wallpaper once per login
  systemd.user.services.waypaper-restore = {
    Unit = {
      Description = "Restore wallpaper via waypaper";
      After = ["swww.service"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.waypaper}/bin/waypaper --restore";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
