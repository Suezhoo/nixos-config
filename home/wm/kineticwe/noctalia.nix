{pkgs, ...}: {
  programs.noctalia = {
    # KineticWE starts Noctalia itself.
    systemd.enable = false;

    settings = {
      # Reapply the generated scheme only after Noctalia has finished updating
      # its palette and application templates. This updates kdeglobals and
      # notifies running KDE applications without a login-time command.
      hooks.colors_changed = [
        "${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark && ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme noctalia"
      ];

    };
  };
}
