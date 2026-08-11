{
  pkgs,
  pkgs-unstable,
  ...
}: {
  # This module describes Suezhoo as a person: applications, development
  # tools, and personal preferences independent of the selected desktop.
  imports = [
    ../../shared/common.nix
    ../../shared/desktop-defaults.nix

    ../../apps/brave.nix
    ../../apps/codium.nix
    ../../apps/kitty.nix
    ../../apps/vesktop.nix
    ../../apps/obs.nix
    ../../apps/zed.nix

    ../../dev/nix-tools.nix
  ];

  home.packages = with pkgs; [
    steam
    obsidian
    pkgs-unstable.spotify
    pkgs-unstable.codex
  ];

  # These associations are personal because another user may choose different
  # applications or may not install Zed at all.
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["org.kde.dolphin.desktop"];
      "text/plain" = ["dev.zed.Zed.desktop"];
      "application/x-zerosize" = ["dev.zed.Zed.desktop"];
    };
  };

  programs.git = {
    enable = true;
    settings = {
      user.name = "Suezhoo";
      user.email = "suezhoo@outlook.com";
      init.defaultBranch = "main";
    };
  };
}
