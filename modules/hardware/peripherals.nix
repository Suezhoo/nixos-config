{pkgs, ...}: {
  # Keep the device access and kernel support needed to run OpenRGB manually,
  # without enabling the always-running OpenRGB SDK server.
  services.udev.packages = [pkgs.openrgb];
  boot.kernelModules = [
    "i2c-dev"
    "i2c-piix4"
  ];

  # Logitech receiver support and the ratbag daemon used by Piper.
  hardware.logitech.wireless.enable = true;
  services.ratbagd.enable = true;

  environment.systemPackages = with pkgs; [
    openrgb
    piper
  ];
}
