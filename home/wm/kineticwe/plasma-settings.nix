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
