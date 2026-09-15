{
  lib,
  pkgs,
  ...
}: {
  xdg.configFile."noctalia/templates/hyprland.conf".text = ''
    general {
        col.active_border = rgb({{colors.primary.default.hex_stripped}})
        col.inactive_border = rgb({{colors.surface.default.hex_stripped}})
    }
  '';

  # Keep the known physical layout and stable refresh-rate combination used by
  # the Niri profile. Hyprland accepts the exact modes advertised by the three
  # displays.
  wayland.windowManager.hyprland.settings = {
    monitor = lib.mkForce [
      "DP-4,1920x1080@239.760,0x180,1"
      "DP-3,2560x1440@240.070,1920x0,1"
      "DP-2,1920x1080@120.000,4480x180,1"
    ];

    # Hyprland requires globally unique workspace names, so qualify each local
    # 1-5 with its monitor internally. Zero-pad the internal slot so workspace
    # 10 sorts after 9; Noctalia displays the leading number without padding,
    # making every monitor look and behave like an independent Niri workspace
    # set. Keep five selectors visible when empty; the number bindings create
    # workspaces 6-10 on demand.
    workspace = builtins.concatLists (map
      (monitorName:
        map
        (slot: let
          paddedSlot = lib.fixedWidthNumber 2 slot;
        in "name:${paddedSlot}@${monitorName}, monitor:${monitorName}, persistent:true${lib.optionalString (slot == 1) ", default:true"}")
        (lib.range 1 5))
      ["DP-3" "DP-4" "DP-2"]);

    general.layout = lib.mkForce "scrolling";

    # Hyprland's built-in scrolling layout is the equivalent of Niri's
    # infinitely growing horizontal tape. Reuse the same half-screen default
    # and the familiar one-third/half/two-thirds width presets.
    scrolling = {
      fullscreen_on_one_column = false;
      column_width = 0.5;
      focus_fit_method = 1;
      follow_focus = true;
      follow_min_visible = 0.25;
      explicit_column_widths = "0.333, 0.5, 0.667, 1.0";
      direction = "right";
    };

    "$menu" = lib.mkForce "noctalia msg panel-toggle launcher";

    bind = lib.mkAfter [
      "SUPER ALT, L, exec, noctalia msg session lock"

      # Pan the scrolling tape continuously, like Niri's Super+MMB gesture.
      "SUPER, mouse:274, exec, hypr-pan-scrolling start"

      # Native scrolling-layout controls from Hyprland's documented layout
      # messages.
      "SUPER, minus, layoutmsg, colresize -0.1"
      "SUPER, equal, layoutmsg, colresize +0.1"
      "SUPER, Home, layoutmsg, fit tobeg"
      "SUPER, End, layoutmsg, fit toend"
      "SUPER CTRL, C, layoutmsg, fit visible"
      "SUPER, comma, layoutmsg, swapcol l"
      "SUPER, period, layoutmsg, swapcol r"
    ];

    bindr = ["SUPER, mouse:274, exec, hypr-pan-scrolling stop"];
  };

  # Load this after the declarative base settings so the current wallpaper
  # palette wins over their static fallback colors.
  wayland.windowManager.hyprland.extraConfig = ''
    source = ~/.config/hypr/noctalia.conf
  '';

  # Run Noctalia independently of the compositor. The shared shell module owns
  # its visible configuration; this module only supplies session integration.
  programs.noctalia = {
    systemd.enable = true;

    settings = {
      hooks.colors_changed = [
        ''${pkgs.kitty}/bin/kitty +runpy "from kitty.utils import reload_conf_in_all_kitties; reload_conf_in_all_kitties()" || ${pkgs.procps}/bin/pkill -USR1 -x kitty || true''
        "${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark && ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme noctalia"
        "${pkgs.hyprland}/bin/hyprctl reload"
      ];

      theme.templates.user."hyprland-wallpaper" = {
        input_path = "$XDG_CONFIG_HOME/noctalia/templates/hyprland.conf";
        output_path = "$XDG_CONFIG_HOME/hypr/noctalia.conf";
      };
    };
  };

  home.sessionVariables.QT_QPA_PLATFORMTHEME = "kde";

  home.packages = [
    pkgs.kdePackages.plasma-integration
    (pkgs.writeShellScriptBin "dolphin" ''
      export QT_QPA_PLATFORMTHEME=kde
      export QT_PLUGIN_PATH="${pkgs.kdePackages.plasma-integration}/lib/qt-6/plugins''${QT_PLUGIN_PATH:+:$QT_PLUGIN_PATH}"
      exec ${pkgs.kdePackages.dolphin}/bin/dolphin "$@"
    '')
  ];

  # Applications launched by Noctalia must survive a shell restart on rebuild.
  systemd.user.services.noctalia.Service.KillMode = "process";
}
