# modules/gpu/nvidia.nix
{
  config,
  pkgs,
  lib,
  ...
}: {
  # Use the NVIDIA driver
  services.xserver.videoDrivers = ["nvidia"];

  # Modern NVIDIA on Wayland (Ada 4080): use the open kernel module.
  hardware.nvidia = {
    open = true; # satisfies >=560 assertion and works well on Wayland
    modesetting.enable = true; # sets nvidia-drm.modeset=1 automatically
    nvidiaSettings = true; # optional GUI tool
    powerManagement.enable = true;
    powerManagement.finegrained = true;
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
}
