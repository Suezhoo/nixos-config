{pkgs, ...}: {
  imports = [
    ./fonts.nix
    ./gaming.nix
    ./hardware/peripherals.nix
    ./services/remote-desktop.nix
  ];

  # Enable modern CLI + flakes permanently
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Basics
  time.timeZone = "Europe/Brussels";
  i18n.defaultLocale = "en_US.UTF-8";

  # Network connections and desktop network controls.
  networking.networkmanager.enable = true;

  # Docker daemon and command-line client. Users still need membership in the
  # docker group, configured in their user module, to run it without sudo.
  virtualisation.docker.enable = true;

  # Firmware for hardware such as Wi-Fi, audio, and other peripherals.
  hardware.enableRedistributableFirmware = true;
  services.fwupd.enable = true;

  # Periodically notify SSDs which deleted blocks can be reclaimed.
  services.fstrim.enable = true;

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

  };

  # Allow graphical file managers to mount removable drives.
  services.udisks2.enable = true;
  services.gvfs.enable = true;

  # Required for Home Manager's desktop appearance settings.
  programs.dconf.enable = true;

  # Compressed RAM-backed swap for extra protection under memory pressure.
  zramSwap.enable = true;

  # Handy tools
  environment.systemPackages = with pkgs; [
    git
    gh
    wget
    curl
    yazi
    cmatrix
    dmidecode
    kitty
    kitty-themes
    kdePackages.dolphin # file explorer
    kdePackages.kio # D-Bus file-opening services used by Dolphin outside Plasma
    kdePackages.kservice # KDE application/MIME cache tools such as kbuildsycoca6
    vlc # video player
    htop # ram display
    btop # cpu display

    pavucontrol # audio
    wdisplays # for arranging display layout
  ];

  # Dolphin runs outside Plasma in the Niri/Hyprland sessions. Give KService
  # the application menu definition it normally receives from a Plasma
  # session so MIME handlers can be resolved on double-click.
  environment.etc."xdg/menus/applications.menu".source =
    "${pkgs.kdePackages.plasma-workspace}/etc/xdg/menus/plasma-applications.menu";

  # Dolphin's KIO application chooser addresses the KDE portal backend
  # directly, even in the Niri and Hyprland sessions. Other backends cannot
  # satisfy that D-Bus name, so keep KDE's backend available alongside them.
  xdg.portal.extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];

  # Enable Electron apps for Wayland
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1"; # enable Wayland for Electron apps by default
    GTK_USE_PORTAL = "1"; # good to keep for file dialogs/screenshare
  };
}
