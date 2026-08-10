{
  inputs,
  pkgs,
  ...
}: {
  imports = [./fonts.nix];

  # Enable modern CLI + flakes permanently
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Basics
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Network connections and desktop network controls.
  networking.networkmanager.enable = true;

  # Firmware for hardware such as Wi-Fi, audio, and other peripherals.
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # PipeWire provides desktop audio through ALSA, PulseAudio, and JACK.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # System-wide noise-suppressed QuadCast input for calls and games.
    extraConfig.pipewire."60-rnnoise-quadcast" = {
      "context.modules" = [
        {
          name = "libpipewire-module-filter-chain";
          args = {
            "node.description" = "HyperX QuadCast (Noise Suppressed)";
            "media.name" = "HyperX QuadCast (Noise Suppressed)";
            "audio.channels" = 2;
            "audio.position" = ["FL" "FR"];

            "filter.graph" = {
              nodes = [
                {
                  type = "ladspa";
                  name = "rnnoise";
                  plugin = "${pkgs.rnnoise-plugin}/lib/ladspa/librnnoise_ladspa.so";
                  label = "noise_suppressor_stereo";
                  control."VAD Threshold (%)" = 60.0;
                }
              ];
            };

            "capture.props" = {
              "node.name" = "capture.rnnoise_quadcast";
              "node.passive" = true;
              "audio.channels" = 2;
              "audio.position" = ["FL" "FR"];
              "target.object" = "alsa_input.usb-Kingston_HyperX_Quadcast_4110-00.analog-stereo";
            };

            "playback.props" = {
              "node.name" = "rnnoise_quadcast";
              "node.description" = "HyperX QuadCast (Noise Suppressed)";
              "media.class" = "Audio/Source";
              "audio.channels" = 2;
              "audio.position" = ["FL" "FR"];
            };
          };
        }
      ];
    };

    wireplumber.extraConfig."51-rename-sony-audio" = {
      "monitor.alsa.rules" = [
        {
          matches = [
            {
              "node.name" = "alsa_output.pci-0000_01_00.1.hdmi-stereo-extra1";
            }
          ];

          actions.update-props = {
            "node.description" = "Sony INZONE M10S Headphones";
            "node.nick" = "Sony INZONE M10S Headphones";
          };
        }
      ];
    };
  };

  # Allow graphical file managers to mount removable drives.
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Install access rules for Logitech wireless receivers. Use the newer
  # Solaar release because the stable 25.05 version predates PRO X 2 support.
  hardware.logitech.wireless.enable = true;

  # Required for Home Manager's desktop appearance settings.
  programs.dconf.enable = true;

  # Compressed RAM-backed swap for extra protection under memory pressure.
  zramSwap.enable = true;

  # Enable ratbagd for Piper (Mouse setting manager GUI)
  services.ratbagd.enable = true;

  # Handy tools
  environment.systemPackages = with pkgs; [
    git
    gh
    vim
    neovim
    wget
    curl
    firefox
    kitty
    kitty-themes
    foot
    fastfetch
    kdePackages.dolphin # file explorer
    vlc # video player

    piper # mice gui
    pavucontrol # audio
    wdisplays # for arranging display layout
  ];

  # Enable Electron apps for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # enable Wayland for Electron apps by default
    GTK_USE_PORTAL = "1"; # good to keep for file dialogs/screenshare
  };
}
