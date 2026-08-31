# modules/gpu/nvidia.nix
{
  config,
  pkgs,
  inputs,
  ...
}: let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
in {
  # Use the NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  # Use the proprietary kernel module for the RTX 4080. This keeps the
  # userspace driver unchanged while avoiding open-module regressions.
  hardware.nvidia = {
    # Use the latest NVIDIA driver supplied by the active kernel package set.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = false;
    modesetting.enable = true; # sets nvidia-drm.modeset=1 automatically
    nvidiaSettings = true; # optional GUI tool
    powerManagement.enable = true;
  };

  # GL/Vulkan stack and NVIDIA's NVDEC-to-VA-API compatibility driver.
  hardware.graphics = {
    enable = true;
    enable32Bit = true; # 32-bit for Steam/Proton etc.
    extraPackages = [pkgs.nvidia-vaapi-driver];
  };

  # `nvidia-settings` cannot expose Digital Vibrance controls to a Wayland
  # compositor. nvibrant talks to the NVIDIA modesetting driver directly.
  environment.systemPackages = with pkgs; [
    libva-utils
    vdpauinfo
    vulkan-tools
    pkgs-unstable.nvibrant
  ];
}
