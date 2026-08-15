{
  config,
  pkgs,
  ...
}: let
  obsWebsocketSetup = pkgs.writeShellScript "obs-websocket-setup" ''
    set -eu

    state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/obs-websocket"
    password_file="$state_dir/password"
    websocket_dir="''${XDG_CONFIG_HOME:-$HOME/.config}/obs-studio/plugin_config/obs-websocket"
    websocket_config="$websocket_dir/config.json"

    umask 077
    mkdir -p "$state_dir" "$websocket_dir"

    if [[ ! -s "$password_file" ]]; then
      ${pkgs.openssl}/bin/openssl rand -hex 32 > "$password_file"
    fi
    chmod 600 "$password_file"

    temporary="$(${pkgs.coreutils}/bin/mktemp "$websocket_dir/.config.json.XXXXXX")"
    trap '${pkgs.coreutils}/bin/rm -f "$temporary"' EXIT

    if ${pkgs.jq}/bin/jq -e 'type == "object"' "$websocket_config" >/dev/null 2>&1; then
      source_config="$websocket_config"
    else
      source_config="$(${pkgs.coreutils}/bin/mktemp "$websocket_dir/.source.json.XXXXXX")"
      printf '{}\n' > "$source_config"
      trap '${pkgs.coreutils}/bin/rm -f "$temporary" "$source_config"' EXIT
    fi

    ${pkgs.jq}/bin/jq --rawfile password "$password_file" '
      . + {
        alerts_enabled: false,
        auth_required: true,
        first_load: false,
        server_enabled: true,
        server_password: ($password | rtrimstr("\n")),
        server_port: 4455
      }
    ' "$source_config" > "$temporary"

    chmod 600 "$temporary"
    ${pkgs.coreutils}/bin/mv -f "$temporary" "$websocket_config"
    trap - EXIT
    if [[ "$source_config" != "$websocket_config" ]]; then
      ${pkgs.coreutils}/bin/rm -f "$source_config"
    fi
  '';

  saveObsReplay = pkgs.writeShellScriptBin "obs-save-replay" ''
    set -eu

    password_file="''${XDG_STATE_HOME:-$HOME/.local/state}/obs-websocket/password"
    if [[ ! -s "$password_file" ]]; then
      echo "OBS WebSocket password is missing; restart the OBS replay-buffer service." >&2
      exit 1
    fi

    password="$(<"$password_file")"
    export OBS_WEBSOCKET_URL="obsws://localhost:4455/$password"
    exec ${pkgs.obs-cmd}/bin/obs-cmd replay save
  '';
in {
  home.packages = [
    pkgs.obs-cmd
    saveObsReplay
  ];

  programs.obs-studio = {
    enable = true;
    package = pkgs.obs-studio.override {
      cudaSupport = true;
    };
    plugins = [
      pkgs.obs-studio-plugins.obs-pipewire-audio-capture
      pkgs.obs-studio-plugins.obs-vkcapture
    ];
  };

  # Generate a machine-local WebSocket password outside the Nix store, apply
  # it before OBS starts, and keep the replay buffer available for global clips.
  systemd.user.services.obs-replay-buffer = {
    Unit = {
      Description = "OBS Studio replay buffer";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      Type = "simple";
      ExecStartPre = obsWebsocketSetup;
      ExecStart = "${config.programs.obs-studio.finalPackage}/bin/obs --minimize-to-tray --startreplaybuffer";
      Restart = "on-failure";
      RestartSec = 3;
    };

    Install.WantedBy = ["graphical-session.target"];
  };
}
