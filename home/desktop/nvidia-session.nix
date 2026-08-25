# home/desktop/nvidia-session.nix
{
  lib,
  pkgs,
  pkgs-unstable,
  ...
}: {
  home.sessionVariables = {
    # Expose NVDEC through VA-API for Chromium-based browsers.
    LIBVA_DRIVER_NAME = "nvidia";
    NVD_BACKEND = "direct";
  };

  # NVIDIA reports seven physical display ports. The connected monitors are
  # the second (right), fourth (center), and sixth (left) entries.
  systemd.user.services.nvibrant = {
    Unit = {
      Description = "Apply NVIDIA Digital Vibrance";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "oneshot";
      ExecStartPre = "${pkgs.coreutils}/bin/sleep 3";
      ExecStart = "${lib.getExe pkgs-unstable.nvibrant} 0 450 0 450 0 450 0";
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
