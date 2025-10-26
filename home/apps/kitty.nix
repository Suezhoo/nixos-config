{pkgs, ...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      cursor_shape = "beam";
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
      hide_window_decorations = "yes";
      background_opacity = "1.0";
      disable_ligatures = "always";
    };

    theme = "Tokyo Night";
  };

  home.packages = [
    (pkgs.nerdfonts.override {fonts = ["JetBrainsMono" "FiraCode"];})
  ];
}
