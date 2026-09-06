{...}: {
  programs.hyprland = {
    enable = true;
    # The Hyprland session is launched through UWSM so graphical-session
    # targets and the shell's user services share the compositor lifecycle.
    # Enabling this explicitly also installs UWSM's required systemd units.
    withUWSM = true;
    xwayland.enable = true;
  };
}
