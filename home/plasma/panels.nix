{pkgs, ...}: {
  programs.plasma.panels = [
    # Global panel
    {
      location = "top";
      height = 40;
      floating = true;
      opacity = "translucent";
      lengthMode = "fill";

      widgets = [
        "org.kde.plasma.kickoff" # app launcher
        "org.kde.plasma.panelspacer"
        "org.kde.plasma.digitalclock"
        "org.kde.plasma.panelspacer"
        "org.kde.plasma.systemtray"
      ];
    }

    # Apps panel
    {
      location = "bottom";
      height = 40;
      floating = true;
      opacity = "translucent";
      hiding = "windowsgobelow";
      lengthMode = "fit";

      widgets = [
        "org.kde.plasma.icontasks"
      ];
    }
  ];
}
# [Containments][38]
# activityId=
# formfactor=2
# immutability=1
# lastScreen=0
# location=3
# plugin=org.kde.panel
# wallpaperplugin=org.kde.image
# [Containments][38][Applets][39]
# immutability=1
# plugin=org.kde.plasma.digitalclock
# [Containments][38][Applets][39][Configuration]
# PreloadWeight=60
# popupHeight=450
# popupWidth=560
# [Containments][38][Applets][39][Configuration][ConfigDialog]
# DialogHeight=540
# DialogWidth=720
# [Containments][38][Applets][40]
# immutability=1
# plugin=org.kde.plasma.systemtray
# [Containments][38][Applets][40][Configuration]
# SystrayContainmentId=41

