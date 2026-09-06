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

    ../../apps/browsers/brave.nix
    ../../apps/browsers/librewolf.nix
    ../../apps/browsers/firefox.nix
    ../../apps/editors/codium.nix
    ../../apps/fish.nix
    ../../apps/kitty.nix
    ../../apps/thunderbird.nix
    ../../apps/vesktop.nix
    ../../apps/obs.nix
    ../../apps/editors/rider.nix
    ../../apps/editors/zed.nix
    ../../apps/remote-desktop

    ../../bundles/development.nix
    ../../bundles/creative.nix
    ../../bundles/gaming.nix

    ../../cli/fastfetch.nix
  ];

  home.packages = with pkgs; [
    obsidian
    kdePackages.filelight # WizTree for linux (storage file viewer)
    pkgs-stable.spotify
    qbittorrent # torrent client

    # unstable
    pkgs-unstable.codex
  ];

  # These associations are personal because another user may choose different
  # applications or may not install Zed at all.
  xdg.desktopEntries.brave-pdf = {
    name = "Brave PDF Viewer";
    comment = "Open PDF documents in Brave";
    exec = "${pkgs.brave}/bin/brave %U";
    terminal = false;
    type = "Application";
    mimeType = ["application/pdf"];
    settings.NoDisplay = "true";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "application/pdf" = ["brave-pdf.desktop"];
      "x-scheme-handler/discord" = ["vesktop.desktop"];
    };
    defaultApplications = {
      "application/pdf" = ["brave-pdf.desktop"];
      "application/xhtml+xml" = ["brave-browser.desktop"];
      "inode/directory" = ["org.kde.dolphin.desktop"];
      "text/plain" = ["dev.zed.Zed.desktop"];
      "application/x-zerosize" = ["dev.zed.Zed.desktop"];
      "text/html" = ["brave-browser.desktop"];
      "x-scheme-handler/discord" = ["vesktop.desktop"];
      "x-scheme-handler/http" = ["brave-browser.desktop"];
      "x-scheme-handler/https" = ["brave-browser.desktop"];
    };
  };

  # Applications may rewrite this file at runtime. Keep the declarative MIME
  # associations authoritative instead of repeatedly creating backup conflicts.
  xdg.configFile."mimeapps.list".force = true;

  # Apply the most recently selected OpenRGB startup profile at login. Loading
  # a profile through the CLI does not open the GUI and exits once it is done.
  xdg.configFile."autostart/OpenRGB.desktop" = {
    force = true;
    text = ''
      [Desktop Entry]
      Type=Application
      Name=OpenRGB
      Comment=Apply the last-used RGB profile
      Exec=${pkgs.openrgb}/bin/openrgb --profile "pink all around"
      Terminal=false
    '';
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
