{pkgs, ...}: {
  programs.plasma = {
    enable = true;

    panels = [
      {
        location = "top";
        widgets = [
          "org.kde.plasma.kickoff" # app launcher
        ];
      }
    ];
  };
}
