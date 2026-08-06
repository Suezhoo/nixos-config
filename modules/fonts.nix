{pkgs, ...}: {
  fonts = {
    # NixOS' maintained baseline set provides sensible Unicode, document, and
    # legacy compatibility coverage. The packages below add the families we
    # explicitly want available to desktop applications.
    enableDefaultPackages = true;
    fontDir.enable = true;

    packages = with pkgs; [
      # General UI and web/document compatibility.
      ubuntu-classic
      inter
      roboto
      liberation_ttf
      freefont_ttf

      # Broad language and emoji coverage.
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      noto-fonts-color-emoji

      # Common publishing and programming families.
      source-sans
      source-serif
      source-code-pro
      fira
      fira-code
      roboto-mono
      cascadia-code

      # Icons and patched terminal/status-bar glyphs.
      font-awesome
      nerd-fonts.monaspace
      nerd-fonts.jetbrains-mono
      nerd-fonts.symbols-only
    ];

    fontconfig = {
      useEmbeddedBitmaps = true;
      defaultFonts = {
        sansSerif = ["Ubuntu" "Noto Sans" "DejaVu Sans"];
        serif = ["Noto Serif" "Liberation Serif" "DejaVu Serif"];
        monospace = [
          "MonaspiceNe Nerd Font Mono"
          "Noto Sans Mono CJK JP"
          "DejaVu Sans Mono"
        ];
        emoji = ["Noto Color Emoji"];
      };
    };
  };
}
