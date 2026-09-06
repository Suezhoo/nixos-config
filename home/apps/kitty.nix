{...}: {
  programs.kitty = {
    enable = true;

    extraConfig = "include themes/noctalia.conf";

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
      # Ask compositors implementing ext-background-effect (including Niri
      # 26.04+) to blur the content visible through Kitty's background.
      background_blur = 1;
      disable_ligatures = "always";
    };
  };
}
