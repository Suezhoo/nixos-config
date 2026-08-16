{...}: {
  # Low-latency desktop and game-streaming host for Moonlight clients. The
  # NixOS module also configures uinput, service discovery, and the user unit.
  services.sunshine = {
    enable = true;
    autoStart = true;
    openFirewall = true;
  };
}
