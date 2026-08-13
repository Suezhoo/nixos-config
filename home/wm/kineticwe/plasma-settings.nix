{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.plasma-manager.homeModules.plasma-manager];

  programs.plasma = {
    enable = true;

    # Keep settings not listed here editable through System Settings. We can
    # enable overrideConfig after the rest of the desired KDE state is captured.
    overrideConfig = false;
    configFile."kwalletrc"."Wallet"."Enabled" = true;

    # Match the complete application class detected by System Settings so the
    # opacity rule applies to every native Zed window.
    window-rules = [
      {
        description = "Zed opacity";
        match.window-class = ".zed-editor-wrapped dev.zed.Zed";
        apply = {
          opacityactive = {
            value = 90;
            apply = "force";
          };
          opacityinactive = {
            value = 90;
            apply = "force";
          };
        };
      }
    ];

    shortcuts.kwin = {
      # Windows-style show-desktop toggle (called "Peek at Desktop" by KWin).
      "Show Desktop" = "Meta+D";

      # Toggle maximization while keeping the compositor's outer gaps visible.
      "Window Maximize" = "Meta+F";
    };

    hotkeys.commands = {
      "open-kitty" = {
        name = "Open Kitty";
        key = "Meta+T";
        command = "${pkgs.kitty}/bin/kitty";
      };
    };
  };
}
