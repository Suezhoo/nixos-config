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

  # Modern NVIDIA on Wayland (Ada 4080): use the open kernel module.
  hardware.nvidia = {
    # Use the NVIDIA driver supplied by the active CachyOS kernel package set.
    package = config.boot.kernelPackages.nvidiaPackages.latest;
    open = true; # satisfies >=560 assertion and works well on Wayland
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
