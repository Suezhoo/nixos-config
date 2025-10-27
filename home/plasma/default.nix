{pkgs, ...}: {
  imports = [
    ./keybinds.nix
  ];

  programs.plasma = {
    enable = true;

    # Important: replace existing layout file with the one from nix
    overrideConfig = true;

    panels = [
      {
        location = "bottom";
        widgets = [
          "org.kde.plasma.kickoff" # app launcher
        ];
      }
    ];
  };
}
