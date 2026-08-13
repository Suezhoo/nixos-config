{...}: {
  programs.kitty = {
    enable = true;

    font = {
      name = "JetBrainsMono Nerd Font";
      size = 12;
    };

    settings = {
      cursor_shape = "beam";
      window_padding_width = 8;
      confirm_os_window_close = 0;
      enable_audio_bell = "no";
      hide_window_decorations = "yes";
      background_opacity = "0.9";
      disable_ligatures = "always";
    };

    themeFile = "tokyo_night_night";
  };
}
