# modules/gpu/nvidia.nix
{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.system;
    config.allowUnfree = true;
  };
  nvidia-latest = config.boot.kernelPackages.nvidiaPackages.mkDriver {
    version = "610.43.03";
    sha256_64bit = "sha256-ReLUwTSiPDXlDyU6SqY+fl6NF+PRhdSgfIpY6WEu05I=";
    sha256_aarch64 = "sha256-jSdlXo60ilXLKWKvZfgbBnVqVYuw6zhnGuiDgwxYz94=";
    openSha256 = "sha256-QCXmqo2xNyIwjGv0da2MUC8ex641Mmc5DUI+uRFVwgE=";
    settingsSha256 = "sha256-z/t+SdEQdVJPwjKIRHO02d264Kt47eWiOwwsaxmh4xQ=";
    persistencedSha256 = "sha256-sOKUsAFHh0/COH+nNgbH9+7hWgivOzq4YmTuk9MOFfI=";
  };
in {
  # Use the NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  # Modern NVIDIA on Wayland (Ada 4080): use the open kernel module.
  hardware.nvidia = {
    # Hashes are sourced from the pinned nixpkgs-unstable NVIDIA package.
    # Build it against this system's kernel to keep the initrd compatible.
    package = nvidia-latest;
    open = true; # satisfies >=560 assertion and works well on Wayland
    modesetting.enable = true; # sets nvidia-drm.modeset=1 automatically
    nvidiaSettings = true; # optional GUI tool
    powerManagement.enable = true;
  };

  # GL/Vulkan stack + helper tools
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32-bit for Steam/Proton etc.
    extraPackages = with pkgs; [
      nvidia-vaapi-driver
      libva
      vdpauinfo
      vulkan-tools
    ];
  };

  # `nvidia-settings` cannot expose Digital Vibrance controls to a Wayland
  # compositor. nvibrant talks to the NVIDIA modesetting driver directly.
  environment.systemPackages = [pkgs-unstable.nvibrant];
}
