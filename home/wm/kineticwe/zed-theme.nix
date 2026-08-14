{
  lib,
  pkgs,
  ...
}: let
  # Pin Noctalia's upstream Zed theme, then distribute its wallpaper-generated
  # terminal palette across the main syntax categories.
  upstreamZedTemplate = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/noctalia-dev/community-templates/main/zed/zed.json";
    hash = "sha256-AKuGJ49tJupXgXaRGdd45Vl4yCZffuFNht9objrJshY=";
  };
  wallpaperZedTemplate =
    pkgs.runCommand "noctalia-zed-wallpaper-template.json" {
      nativeBuildInputs = [pkgs.jq];
    } ''
      jq '
        .themes[] |= (
          .appearance as $mode
          | .style.syntax.boolean.color = ("{{colors.terminal_bright_red." + $mode + ".hex}}")
          | .style.syntax.constant.color = ("{{colors.terminal_bright_red." + $mode + ".hex}}")
          | .style.syntax.constructor.color = ("{{colors.terminal_bright_yellow." + $mode + ".hex}}")
          | .style.syntax.function.color = ("{{colors.terminal_normal_magenta." + $mode + ".hex}}")
          | .style.syntax.keyword.color = ("{{colors.terminal_normal_red." + $mode + ".hex}}")
          | .style.syntax.number.color = ("{{colors.terminal_normal_yellow." + $mode + ".hex}}")
          | .style.syntax.property.color = ("{{colors.terminal_bright_blue." + $mode + ".hex}}")
          | .style.syntax.string.color = ("{{colors.terminal_normal_green." + $mode + ".hex}}")
          | .style.syntax.type.color = ("{{colors.terminal_normal_cyan." + $mode + ".hex}}")
          | .style.syntax.variable.color = ("{{colors.terminal_normal_blue." + $mode + ".hex}}")
          | .style.syntax["variable.special"].color = ("{{colors.terminal_bright_magenta." + $mode + ".hex}}")
        )
      ' ${upstreamZedTemplate} > "$out"
    '';
in {
  programs.zed-editor.userSettings.theme = lib.mkForce {
    mode = "system";
    dark = "Noctalia Dark";
    light = "Noctalia Light";
  };

  programs.noctalia.settings.theme.templates.user.zed = {
    input_path = "${wallpaperZedTemplate}";
    output_path = "$XDG_CONFIG_HOME/zed/themes/noctalia.json";
  };
}
