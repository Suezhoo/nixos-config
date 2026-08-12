{inputs, ...}: {
  imports = [inputs.plasma-manager.homeModules.plasma-manager];

  programs.plasma = {
    enable = true;

    # Keep settings not listed here editable through System Settings. We can
    # enable overrideConfig after the rest of the desired KDE state is captured.
    overrideConfig = false;

    shortcuts.kwin = {
      # Windows-style show-desktop toggle (called "Peek at Desktop" by KWin).
      "Show Desktop" = "Meta+D";
    };
  };
}
