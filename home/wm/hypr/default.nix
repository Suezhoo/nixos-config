{pkgs, ...}: let
  # Hyprland workspace names are global, unlike Niri's per-output workspace
  # indices. Qualify the internal name with the output while keeping the local
  # number first so shells such as Noctalia can display only that number.
  hyprLocalWorkspace = pkgs.writeShellScriptBin "hypr-local-workspace" ''
    action="$1"
    slot="$2"

    monitor="$(${pkgs.hyprland}/bin/hyprctl -j monitors | ${pkgs.jq}/bin/jq -r '.[] | select(.focused) | .name')"
    workspace_slot="$(${pkgs.coreutils}/bin/printf '%02d' "$slot")"
    workspace_name="$workspace_slot@$monitor"
    case "$action" in
      focus) dispatcher=workspace ;;
      move) dispatcher=movetoworkspace ;;
      *) exit 2 ;;
    esac

    exec ${pkgs.hyprland}/bin/hyprctl dispatch "$dispatcher" "name:$workspace_name"
  '';

  # Toggle a Niri-like maximized state without telling the client that it is
  # fullscreen. Explicitly clearing both states makes the second press restore
  # the window even when the scrolling layout handles fullscreen internally.
  hyprToggleMaximize = pkgs.writeShellScriptBin "hypr-toggle-maximize" ''
    fullscreen_state="$(${pkgs.hyprland}/bin/hyprctl -j activewindow | ${pkgs.jq}/bin/jq -r '.fullscreen')"

    if [ "$fullscreen_state" = 1 ] || [ "$fullscreen_state" = 3 ]; then
      exec ${pkgs.hyprland}/bin/hyprctl dispatch fullscreenstate "0 0 set"
    else
      exec ${pkgs.hyprland}/bin/hyprctl dispatch fullscreenstate "1 0 set"
    fi
  '';

  # Hyprland's scrolling layout can move its tape by an exact pixel delta, but
  # it does not expose that operation as a continuous mouse dispatcher. Bridge
  # pointer motion to layout messages while Super+MMB is held.
  hyprPanScrolling = pkgs.writeShellScriptBin "hypr-pan-scrolling" ''
    state_dir="''${XDG_RUNTIME_DIR:?}/hypr-pan-scrolling"
    active_file="$state_dir/active"
    lock_dir="$state_dir/lock"

    case "''${1:-}" in
      start)
        ${pkgs.coreutils}/bin/mkdir -p "$state_dir"
        ${pkgs.coreutils}/bin/touch "$active_file"
        if ! ${pkgs.coreutils}/bin/mkdir "$lock_dir" 2>/dev/null; then
          exit 0
        fi
        trap '${pkgs.coreutils}/bin/rm -f "$active_file"; ${pkgs.coreutils}/bin/rmdir "$lock_dir" 2>/dev/null || true' EXIT

        previous_x="$(${pkgs.hyprland}/bin/hyprctl -j cursorpos | ${pkgs.jq}/bin/jq -r .x)"
        while [ -e "$active_file" ]; do
          ${pkgs.coreutils}/bin/sleep 0.016
          current_x="$(${pkgs.hyprland}/bin/hyprctl -j cursorpos | ${pkgs.jq}/bin/jq -r .x)"
          delta=$((current_x - previous_x))
          previous_x="$current_x"
          if [ "$delta" -ne 0 ]; then
            ${pkgs.hyprland}/bin/hyprctl dispatch layoutmsg "move $delta" >/dev/null
          fi
        done
        ;;
      stop)
        ${pkgs.coreutils}/bin/rm -f "$active_file"
        ;;
      *) exit 2 ;;
    esac
  '';
in {
  # Make hyprland visible in login screen (desktop manager)
  xdg.portal.enable = true;
  xdg.portal.extraPortals = with pkgs; [
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
  ];
  xdg.portal.config.hyprland = {
    default = ["hyprland" "gtk"];
    "org.freedesktop.impl.portal.ScreenCast" = "hyprland";
    "org.freedesktop.impl.portal.Screenshot" = "hyprland";
    "org.freedesktop.impl.portal.FileChooser" = "gtk";
  };

  wayland.windowManager.hyprland.enable = true; # enable Hyprland
  wayland.windowManager.hyprland.configType = "hyprlang";

  # Required for default hyprland configuration
  programs.kitty.enable = true;
  home.packages = [
    hyprLocalWorkspace
    hyprPanScrolling
    hyprToggleMaximize
  ];

  wayland.windowManager.hyprland.settings = {
    # This is an example Hyprland config file for Nix.
    # Refer to the wiki for more information.
    # https://wiki.hypr.land/Configuring/
    # https://wiki.hypr.land/Nix/
    # https://wiki.hypr.land/Nix/Hyprland-on-NixOS/
    # https://wiki.hypr.land/Nix/Hyprland-on-Home-Manager/

    # Please note not all available settings / options are set here.
    # For a full list, see the wiki

    # You can split this configuration into multiple files
    # Create your files separately and then link them to this file like this:
    # source = ~/.config/hypr/myColors.conf
    # todo: make the line above nix-ish

    ################
    ### MONITORS ###
    ################

    # See https://wiki.hypr.land/Configuring/Monitors/
    monitor = ",1920x1080@240,0x0,1";

    ###################
    ### MY PROGRAMS ###
    ###################

    # See https://wiki.hypr.land/Configuring/Keywords/

    # Set programs that you use

    "$terminal" = "kitty";
    "$fileManager" = "dolphin";
    "$menu" = "wofi --show drun";

    #################
    ### AUTOSTART ###
    #################

    # Autostart necessary processes (like notifications daemons, status bars, etc.)
    # Or execute your favorite apps at launch like this:

    # Waybar is managed by its Home Manager user service.
    "exec-once" = [];

    #############################
    ### ENVIRONMENT VARIABLES ###
    #############################

    # See https://wiki.hypr.land/Configuring/Environment-variables/

    env = [
      "XCURSOR_SIZE,24"
      "HYPRCURSOR_SIZE,24"
    ];

    ###################
    ### PERMISSIONS ###
    ###################

    # See https://wiki.hypr.land/Configuring/Permissions/
    # Please note permission changes here require a Hyprland restart and are not applied on-the-fly
    # for security reasons

    # ecosystem = {
    #   enforce_permissions = 1;
    # };

    # permission = [
    #   "/usr/(bin|local/bin)/grim, screencopy, allow"
    #   "/usr/(lib|libexec|lib64)/xdg-desktop-portal-hyprland, screencopy, allow"
    #   "/usr/(bin|local/bin)/hyprpm, plugin, allow"
    # ];

    #####################
    ### LOOK AND FEEL ###
    #####################

    # Refer to https://wiki.hypr.land/Configuring/Variables/

    # https://wiki.hypr.land/Configuring/Variables/#general
    general = {
      # Match Niri's breathing room, including between maximized windows and
      # layer-shell panels such as Waybar/Noctalia.
      gaps_in = 8;
      gaps_out = 16;

      border_size = 2;

      # Solid fallbacks for shells that do not generate a wallpaper palette.
      # The Noctalia profile overrides these from its current palette.
      "col.active_border" = "rgb(7fc8ff)";
      "col.inactive_border" = "rgba(595959aa)";

      # Set to true enable resizing windows by clicking and dragging on borders and gaps
      resize_on_border = false;

      # Please see https://wiki.hypr.land/Configuring/Tearing/ before you turn this on
      allow_tearing = false;

      layout = "dwindle";
    };

    # https://wiki.hypr.land/Configuring/Variables/#decoration
    decoration = {
      rounding = 10;
      #  rounding_power = 2;

      # Change transparency of focused and unfocused windows
      active_opacity = 1.0;
      inactive_opacity = 1.0;

      #   shadow = {
      #    enabled = true;
      #   range = 4;
      #  render_power = 3;
      #  color = "rgba(1a1a1aee)";
      # };

      # https://wiki.hypr.land/Configuring/Variables/#blur
      blur = {
        enabled = true;
        size = 3;
        passes = 1;

        vibrancy = 0.1696;
      };
    };

    # https://wiki.hypr.land/Configuring/Variables/#animations
    animations = {
      enabled = "yes, please :)";

      # Default animations, see https://wiki.hypr.land/Configuring/Animations/ for more

      bezier = [
        "easeOutQuint,0.23,1,0.32,1"
        "easeInOutCubic,0.65,0.05,0.36,1"
        "linear,0,0,1,1"
        "almostLinear,0.5,0.5,0.75,1.0"
        "quick,0.15,0,0.1,1"
      ];

      animation = [
        "global, 1, 10, default"
        "border, 1, 5.39, easeOutQuint"
        "windows, 1, 4.79, easeOutQuint"
        "windowsIn, 1, 4.1, easeOutQuint, popin 87%"
        "windowsOut, 1, 1.49, linear, popin 87%"
        "fadeIn, 1, 1.73, almostLinear"
        "fadeOut, 1, 1.46, almostLinear"
        "fade, 1, 3.03, quick"
        "layers, 1, 3.81, easeOutQuint"
        "layersIn, 1, 4, easeOutQuint, fade"
        "layersOut, 1, 1.5, linear, fade"
        "fadeLayersIn, 1, 1.79, almostLinear"
        "fadeLayersOut, 1, 1.39, almostLinear"
        "workspaces, 1, 1.94, almostLinear, fade"
        #    "workspacesIn, 1, 1.21, almostLinear, fade"
        #   "workspacesOut, 1, 1.94, almostLinear, fade"
        #  "zoomFactor, 1, 7, quick"
      ];
    };

    # Ref https://wiki.hypr.land/Configuring/Workspace-Rules/
    # "Smart gaps" / "No gaps when only"
    # uncomment all if you wish to use that.
    # workspace = [
    #   "w[tv1], gapsout:0, gapsin:0"
    #   "f[1], gapsout:0, gapsin:0"
    # ];
    # windowrule = [
    #   "bordersize 0, floating:0, onworkspace:w[tv1]"
    #   "rounding 0, floating:0, onworkspace:w[tv1]"
    #   "bordersize 0, floating:0, onworkspace:f[1]"
    #   "rounding 0, floating:0, onworkspace:f[1]"
    # ];

    # See https://wiki.hypr.land/Configuring/Dwindle-Layout/ for more
    dwindle = {
      preserve_split = true; # You probably want this
    };

    # See https://wiki.hypr.land/Configuring/Master-Layout/ for more
    master = {
      new_status = "master";
    };

    # https://wiki.hypr.land/Configuring/Variables/#misc
    misc = {
      force_default_wallpaper = 0; # Set to 0 or 1 to disable the anime mascot wallpapers
      disable_hyprland_logo = false; # If true disables the random hyprland logo / anime girl background. :(
    };

    #############
    ### INPUT ###
    #############

    # https://wiki.hypr.land/Configuring/Variables/#input
    input = {
      kb_layout = "us";
      kb_variant = "";
      kb_model = "";
      kb_options = "";
      kb_rules = "";

      follow_mouse = 1;

      sensitivity = 0; # -1.0 - 1.0, 0 means no modification.
      accel_profile = "flat"; # Match Niri's unaccelerated 1:1 mouse motion.

      touchpad = {
        natural_scroll = false;
      };
    };

    ###################
    ### KEYBINDINGS ###
    ###################

    # See https://wiki.hypr.land/Configuring/Keywords/
    "$mainMod" = "SUPER"; # Sets "Windows" key as main modifier

    bind = [
      # Core application/session bindings.
      "$mainMod, T, exec, $terminal"
      "$mainMod, Q, killactive,"
      "$mainMod SHIFT, E, exit,"
      "$mainMod, E, exec, $fileManager"
      "$mainMod, Space, exec, $menu"
      # Super+F toggles a Niri-like maximized state and reliably restores the
      # window on the second press. Shift+F toggles true fullscreen.
      "$mainMod, F, fullscreen, 1"
      "$mainMod SHIFT, F, fullscreen, 0"
      "$mainMod, V, togglefloating,"

      # Conventional Hyprland navigation. The scrolling layout's focus message
      # handles horizontal columns and wraps at either end of the tape.
      "$mainMod, left, layoutmsg, focus l"
      "$mainMod, right, layoutmsg, focus r"
      "$mainMod, up, movefocus, u"
      "$mainMod, down, movefocus, d"

      # Shift plus an arrow moves the active window in that direction.
      "$mainMod SHIFT, left, movewindow, l"
      "$mainMod SHIFT, right, movewindow, r"
      "$mainMod SHIFT, up, movewindow, u"
      "$mainMod SHIFT, down, movewindow, d"

      # Niri-like per-monitor workspace numbers. The helper resolves 1-10
      # within the currently focused output.
      "$mainMod, 1, exec, hypr-local-workspace focus 1"
      "$mainMod, 2, exec, hypr-local-workspace focus 2"
      "$mainMod, 3, exec, hypr-local-workspace focus 3"
      "$mainMod, 4, exec, hypr-local-workspace focus 4"
      "$mainMod, 5, exec, hypr-local-workspace focus 5"
      "$mainMod, 6, exec, hypr-local-workspace focus 6"
      "$mainMod, 7, exec, hypr-local-workspace focus 7"
      "$mainMod, 8, exec, hypr-local-workspace focus 8"
      "$mainMod, 9, exec, hypr-local-workspace focus 9"
      "$mainMod, 0, exec, hypr-local-workspace focus 10"

      # Niri uses mainMod + Ctrl + number to move a window/workspace column.
      "$mainMod CTRL, 1, exec, hypr-local-workspace move 1"
      "$mainMod CTRL, 2, exec, hypr-local-workspace move 2"
      "$mainMod CTRL, 3, exec, hypr-local-workspace move 3"
      "$mainMod CTRL, 4, exec, hypr-local-workspace move 4"
      "$mainMod CTRL, 5, exec, hypr-local-workspace move 5"
      "$mainMod CTRL, 6, exec, hypr-local-workspace move 6"
      "$mainMod CTRL, 7, exec, hypr-local-workspace move 7"
      "$mainMod CTRL, 8, exec, hypr-local-workspace move 8"
      "$mainMod CTRL, 9, exec, hypr-local-workspace move 9"
      "$mainMod CTRL, 0, exec, hypr-local-workspace move 10"

      # Example special workspace (scratchpad)
      "$mainMod, S, togglespecialworkspace, magic"
      "$mainMod SHIFT, S, movetoworkspace, special:magic"

      # Scroll through columns on the current workspace.
      "$mainMod, mouse_down, layoutmsg, focus r"
      "$mainMod, mouse_up, layoutmsg, focus l"
    ];

    # Move/resize windows with mainMod + LMB/RMB and dragging
    bindm = [
      "$mainMod, mouse:272, movewindow"
      "$mainMod, mouse:273, resizewindow"
    ];

    # Laptop multimedia keys for volume and LCD brightness
    bindel = [
      ",XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
      ",XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
      ",XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ",XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
      ",XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
      ",XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
    ];

    # Requires playerctl
    bindl = [
      ", XF86AudioNext, exec, playerctl next"
      ", XF86AudioPause, exec, playerctl play-pause"
      ", XF86AudioPlay, exec, playerctl play-pause"
      ", XF86AudioPrev, exec, playerctl previous"
    ];

    ##############################
    ### WINDOWS AND WORKSPACES ###
    ##############################

    # See https://wiki.hypr.land/Configuring/Window-Rules/ for more
    # See https://wiki.hypr.land/Configuring/Workspace-Rules/ for workspace rules

    windowrule = [
      # Example windowrule
      # "float,class:^(kitty)$,title:^(kitty)$"

      # Ignore maximize requests from apps. You'll probably like this.
      "match:class .*, suppress_event maximize"

      # Fix some dragging issues with XWayland
      "match:class ^$, match:title ^$, match:xwayland true, match:float true, match:fullscreen false, match:pin false, no_focus true"
    ];
  };
}
