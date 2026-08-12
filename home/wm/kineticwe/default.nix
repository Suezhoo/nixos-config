{
  inputs,
  pkgs,
  ...
}: {
  # The HM module exposes the session launcher in the user environment. SDDM
  # registration remains the responsibility of modules/sessions/kineticwe.nix.
  imports = [
    inputs.kineticwe.homeModules.default
    ./plasma-settings.nix
  ];

  # Plasma is installed by the system profile, including System Settings and
  # its KCM plugins. KineticWE adds its own KWin-specific KCMs to that base.

  # KWin persists output state in kwinoutputconfig.json. Apply the host's known
  # layout after KineticWE is ready instead of depending on stale state from a
  # previous compositor session.
  systemd.user.services.kineticwe-monitor-layout = {
    Unit = {
      Description = "Apply the moonine KineticWE monitor layout";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = let
        kscreenDoctor = "${pkgs.kdePackages.libkscreen}/bin/kscreen-doctor";
      in ''
        ${kscreenDoctor} \
          output.DP-4.scale.1 output.DP-4.position.0,180 \
          output.DP-3.scale.1 output.DP-3.position.1920,0 \
          output.DP-2.scale.1 output.DP-2.position.4480,180
      '';
    };

    Install.WantedBy = ["graphical-session.target"];
  };

  programs.kineticwe = {
    enable = true;
    autostart = false;
  };
}
