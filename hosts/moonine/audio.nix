{pkgs, ...}: let
  selectSonyAudio = pkgs.writeShellApplication {
    name = "select-sony-audio";
    runtimeInputs = [
      pkgs.coreutils
      pkgs.jq
      pkgs.pipewire
      pkgs.wireplumber
    ];
    text = ''
      card_name="alsa_card.pci-0000_01_00.1"
      monitor_name="SDM27Q10S*10"

      # HDMI profile suffixes describe ALSA routes, not physical display
      # connectors. Resolve the stereo profile through the monitor identity
      # reported in the route's ELD data instead.
      while true; do
        selection="$({ pw-dump 2>/dev/null || true; } | jq -r \
          --arg card "$card_name" \
          --arg monitor "$monitor_name" '
            .[]
            | select(.info.props["device.name"] == $card)
            | . as $device
            | .info.params.EnumRoute[]
            | select(.available == "yes")
            | (.info | index("device.product.name")) as $name_index
            | select($name_index != null and .info[$name_index + 1] == $monitor)
            | .profiles[] as $profile_index
            | $device.info.params.EnumProfile[]
            | select(
                .index == $profile_index
                and .available == "yes"
                and (.name | startswith("output:hdmi-stereo"))
              )
            | [$device.id, .index, .name] | @tsv
          ' | head -n1)"

        if [[ -n "$selection" ]]; then
          IFS=$'\t' read -r device_id profile_id profile_name <<< "$selection"
          current_profile="$({ pw-dump 2>/dev/null || true; } | jq -r \
            --arg card "$card_name" '
              .[]
              | select(.info.props["device.name"] == $card)
              | .info.params.Profile[0].index // empty
            ' | head -n1)"

          if [[ "$current_profile" != "$profile_id" ]]; then
            wpctl set-profile "$device_id" "$profile_id"
          fi

          # Profile changes replace the sink object, so wait for the new one
          # before making it the default.
          for _ in {1..20}; do
            sink_id="$({ pw-dump 2>/dev/null || true; } | jq -r \
              --argjson device "$device_id" \
              --arg profile "''${profile_name#output:}" '
                .[]
                | select(
                    .info.props["media.class"] == "Audio/Sink"
                    and .info.props["device.id"] == $device
                    and .info.props["device.profile.name"] == $profile
                  )
                | .id
              ' | head -n1)"
            if [[ -n "$sink_id" ]]; then
              wpctl set-default "$sink_id"
              break
            fi
            sleep 0.25
          done
        fi

        sleep 5
      done
    '';
  };
in {
  services.pipewire.wireplumber.extraConfig."51-name-sony-audio" = {
    "monitor.alsa.rules" = [
      {
        matches = [
          {
            # This nickname comes from the display's ELD data and remains
            # stable when the HDMI profile suffix changes.
            "node.nick" = "SDM27Q10S*10";
          }
        ];
        actions.update-props = {
          "node.description" = "Sony INZONE M10S Earbuds";
          "node.nick" = "Sony INZONE M10S Earbuds";
          "priority.session" = 2000;
        };
      }
    ];
  };

  # Follow the Sony display by ELD identity across boots, hot-plugs and any
  # HDMI profile renumbering performed by the kernel or NVIDIA driver.
  systemd.user.services.select-sony-audio = {
    description = "Select Sony display audio using its ELD identity";
    wantedBy = ["default.target"];
    wants = ["pipewire.service" "wireplumber.service"];
    after = ["pipewire.service" "wireplumber.service"];
    serviceConfig = {
      ExecStart = "${selectSonyAudio}/bin/select-sony-audio";
      Restart = "on-failure";
      RestartSec = 2;
    };
  };
}
