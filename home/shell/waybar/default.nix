{
  config,
  pkgs,
  lib,
  ...
}: let
  hyprSettings = import ./hypr/settings.nix {};
  niriSettings = import ./niri/settings.nix {};

  cfgDir = config.xdg.configHome or "${config.home.homeDirectory}/.config";
in {
  home.packages = [pkgs.waybar];

  # Shared CSS
  programs.waybar.enable = true;
  programs.waybar.style = builtins.readFile ./waybar.css;

  # Write two configs side-by-side
  xdg.enable = true;
  xdg.configFile."waybar/hypr.jsonc".text = builtins.toJSON hyprSettings;
  xdg.configFile."waybar/niri.jsonc".text = builtins.toJSON niriSettings;

  # Single systemd --user service that auto-picks the right config
  systemd.user.services.waybar = {
    Unit = {
      Description = "Waybar (auto-select per session)";
      After = ["graphical-session-pre.target"];
      PartOf = ["graphical-session.target"];
    };
    Service = {
      ExecStart = "${pkgs.bash}/bin/bash -lc '\
        case \"$XDG_CURRENT_DESKTOP\" in \
          Hyprland) exec ${pkgs.waybar}/bin/waybar -c ${cfgDir}/waybar/hypr.jsonc -s ${cfgDir}/waybar/style.css ;; \
          Niri)     exec ${pkgs.waybar}/bin/waybar -c ${cfgDir}/waybar/niri.jsonc -s ${cfgDir}/waybar/style.css ;; \
          *)        exec ${pkgs.waybar}/bin/waybar -s ${cfgDir}/waybar/style.css ;; \
        esac'";
      Restart = "on-failure";
    };
    Install.WantedBy = ["graphical-session.target"];
  };
}
