{
  pkgs,
  pkgs-stable,
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
    ../../apps/fastfetch.nix
    ../../apps/fish.nix
    ../../apps/kitty.nix
    ../../apps/vesktop.nix
    ../../apps/obs.nix
    ../../apps/zed.nix

    ../../bundles/development.nix
  ];

  home.packages = with pkgs; [
    steam
    obsidian
    gamescope # game compositor to make games run and render same way across all types of linux2
    kdePackages.filelight # WizTree for linux (storage file viewer)
    pkgs-stable.spotify

    # unstable
    pkgs-unstable.codex
  ];

  # These associations are personal because another user may choose different
  # applications or may not install Zed at all.
  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "x-scheme-handler/discord" = ["vesktop.desktop"];
    };
    defaultApplications = {
      "inode/directory" = ["org.kde.dolphin.desktop"];
      "text/plain" = ["dev.zed.Zed.desktop"];
      "application/x-zerosize" = ["dev.zed.Zed.desktop"];
      "x-scheme-handler/discord" = ["vesktop.desktop"];
    };
  };

  # Applications may rewrite this file at runtime. Keep the declarative MIME
  # associations authoritative instead of repeatedly creating backup conflicts.
  xdg.configFile."mimeapps.list".force = true;

  programs.git = {
    enable = true;
    settings = {
      user.name = "Suezhoo";
      user.email = "suezhoo@outlook.com";
      init.defaultBranch = "main";
    };
  };
}
