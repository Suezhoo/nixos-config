{lib, ...}: {
  # A shell supplies compositor integration through this small interface.
  # Niri therefore does not need to know which concrete shell is installed.
  options.local.desktopShell.niri = {
    startup = lib.mkOption {
      type = lib.types.lines;
      default = "";
      description = "KDL startup declarations supplied by the desktop shell.";
    };

    launcherBinding = lib.mkOption {
      type = lib.types.str;
      description = "Complete Niri KDL binding for the shell's launcher.";
    };

    lockBinding = lib.mkOption {
      type = lib.types.str;
      description = "Complete Niri KDL binding for the shell's lock screen.";
    };
  };
}
