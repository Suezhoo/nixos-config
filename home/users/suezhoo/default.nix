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

  programs.git = {
    enable = true;
    settings = {
      user.name = "Suezhoo";
      user.email = "suezhoo@outlook.com";
      init.defaultBranch = "main";
    };
  };
}
