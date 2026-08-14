{
  inputs,
  lib,
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
    # Never reopen applications that were running when the previous Plasma
    # session ended.
    configFile."ksmserverrc"."General"."loginMode" = "emptySession";
    # Give normal windows subtle rounded corners and make focus visible without
    # an oversized frame. KineticWE keeps maximized/fullscreen windows square.
    configFile."kwinrc"."Tiling" = {
      "TilingBorderMode" = "AllWindows";
      "TilingBorderThickness" = 2;
      "TilingBorderColorSourceActive" = "NoctaliaPrimary";
      "TilingBorderColorSourceInactive" = "SystemAccentFaded";
      "TilingCornerRadius" = 8;
    };
    # Noctalia regenerates this color scheme whenever the wallpaper changes;
    # KDE applications such as Dolphin follow this stable scheme name.
    configFile."kdeglobals"."General"."ColorScheme" = "noctalia";

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
      {
        description = "Dolphin opacity";
        match.window-class = ".dolphin-wrapped org.kde.dolphin";
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

  # A rebuild may select the Noctalia scheme after its palette was generated,
  # which does not itself emit a Noctalia colors-changed event. Synchronize an
  # existing generated scheme during Home Manager activation; later wallpaper
  # palette changes are handled live by Noctalia's colors_changed hook.
  home.activation.applyNoctaliaKdeColors = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [[ -f "$HOME/.local/share/color-schemes/noctalia.colors" ]]; then
      # plasma-apply-colorscheme refuses to refresh a scheme that is already
      # selected, even when its file contents changed. Toggle away first so it
      # recopies Noctalia's generated Colors sections into kdeglobals.
      run ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme BreezeDark
      run ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-colorscheme noctalia
    fi
  '';
}
