{pkgs, ...}: {
  home.packages = with pkgs; [
    waypaper # GUI for managing wallpapers
    awww # Animated wallpaper backend (successor to swww)
  ];

  xdg.configFile."waypaper/config.ini".text = ''
    [Settings]
    backend = awww
    fill = fill
    sort = name
    folder = ~/Pictures/wallpapers
    show_all = True
    restore_last = True
    language = en
  '';

  # Start the awww daemon for this user session.
  systemd.user.services.awww = {
    Unit = {
      Description = "awww wallpaper daemon";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.awww}/bin/awww-daemon";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };

  # Restore the last wallpaper once per login
  systemd.user.services.waypaper-restore = {
    Unit = {
      Description = "Restore wallpaper via waypaper";
      After = ["awww.service"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = "${pkgs.waypaper}/bin/waypaper --restore";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
