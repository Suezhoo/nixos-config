{pkgs, ...}: {
  # Install OpenRGB with the udev rules needed to control supported keyboards
  # and other RGB peripherals as an unprivileged desktop user.
  services.hardware.openrgb.enable = true;

  # Logitech receiver support and the ratbag daemon used by Piper.
  hardware.logitech.wireless.enable = true;
  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
    openrgb
    piper
  ];
}
