{pkgs, ...}: let
  # Nixpkgs calls the executable `zeditor`. Keep it for compatibility while
  # also exposing the conventional `zed` command used by Zed's documentation.
  zedWithCli = pkgs.symlinkJoin {
    name = "zed-editor-with-cli";
    paths = [pkgs.zed-editor];
    postBuild = ''
      ln -s zeditor $out/bin/zed
    '';
  };

  prettierLanguages = [
    "CSS"
    "HTML"
    "JavaScript"
    "JSON"
    "JSONC"
    "JSX"
    "Markdown"
    "TypeScript"
    "TSX"
    "YAML"
  ];
in {
  programs.zed-editor = {
    enable = true;
    package = zedWithCli;

    # Tools used by language servers and formatters must be visible to Zed
    # even when it is launched from the desktop rather than a terminal.
    extraPackages = with pkgs; [
      alejandra
      nil
      nodePackages.prettier
      nodePackages.eslint
    ];

    extensions = [
      "material-icon-theme"
      "nix"
      "tokyo-night"
    ];

    userSettings = {
      theme = {
        mode = "dark";
        dark = "Tokyo Night";
        light = "Tokyo Night";
      };
      icon_theme = {
        mode = "dark";
        dark = "Material Icon Theme";
        light = "Material Icon Theme";
      };

      format_on_save = "on";

      languages = builtins.listToAttrs (map (language: {
          name = language;
          value.formatter.external = {
            command = "prettier";
            arguments = ["--stdin-filepath" "{buffer_path}"];
          };
        }) prettierLanguages)
        // {
          Nix = {
            language_servers = ["nil"];
            formatter.external = {
              command = "alejandra";
              arguments = [];
            };
          };
        };

      lsp.nil.settings.nil.formatting.command = ["alejandra"];
    };
  };
}
