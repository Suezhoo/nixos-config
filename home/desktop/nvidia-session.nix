# home/desktop/nvidia-session.nix
{...}: {
  home.sessionVariables = {
    # Prefer Wayland in Electron apps
    NIXOS_OZONE_WL = "1";
    ELECTRON_OZONE_PLATFORM_HINT = "wayland";

    # NVIDIA-friendly Electron GL path (keeps GPU accel)
    ELECTRON_USE_GL = "egl"; # try "egl" if ANGLE misbehaves
    ELECTRON_DISABLE_GPU_SANDBOX = "1"; # helps avoid GPU-process crashes

    # wlroots/Niri friendly knobs
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    WLR_RENDERER = "vulkan";

    # Only keep if you see cursor glitches; otherwise you can remove it
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
