{pkgs, ...}: {
  panels = [
    {
      location = "top";
      widgets = [
        "org.kde.plasma.kickoff" # app launcher
      ];
    }
  ];
}
