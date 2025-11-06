{pkgs, ...}: {
  programs.plasma = {
    enable = true;

    hotkeys.commands = {
      "launch-foot" = {
        name = "Launch Foot";
        key = "Meta+Return";
        command = "foot";
      };
    };
  };
}
