{pkgs, ...}: {
  # Use the NixOS Steam module so its FHS environment receives the active
  # system's 64- and 32-bit graphics drivers. Installing pkgs.steam directly
  # does not provide that integration.
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      # Make OBS Vulkan capture available inside Steam's FHS environment.
      extraEnv.OBS_VKCAPTURE = true;
    };
    extraPackages = with pkgs; [
      obs-studio-plugins.obs-vkcapture
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji
      nerd-fonts.symbols-only
    ];
  };

  # Apply the performance governor and process priority only while a game asks
  # for it. Steam launch option: gamemoderun mangohud %command%
  programs.gamemode = {
    enable = true;
    enableRenice = true;
    settings.general.renice = 10;
  };

  # Keep Gamescope available for games that benefit from an isolated nested
  # compositor. Do not force it globally; that would add another variable to
  # benchmarks and can regress some NVIDIA games.
  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };
}
