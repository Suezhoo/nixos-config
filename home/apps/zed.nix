{
  pkgs,
  pkgs-unstable,
  ...
}: let
  # Nixpkgs calls the executable `zeditor`. Keep it for compatibility while
  # also exposing the conventional `zed` command used by Zed's documentation.
  zedWithCli = pkgs.symlinkJoin {
    name = "zed-editor-with-cli";
    # Use the pinned unstable release to keep Zed current.
    paths = [pkgs-unstable.zed-editor];
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
  # KDE/Dolphin does not always inherit the Home Manager profile PATH when it
  # launches a desktop entry. Use the immutable package path so opening a file
  # through its MIME association always reaches Zed.
  xdg.desktopEntries."dev.zed.Zed" = {
    name = "Zed";
    genericName = "Text Editor";
    comment = "A high-performance code editor";
    exec = "${zedWithCli}/bin/zeditor %U";
    icon = "zed";
    terminal = false;
    categories = ["Utility" "TextEditor" "Development" "IDE"];
    mimeType = ["text/plain" "application/x-zerosize" "x-scheme-handler/zed"];
  };

  programs.zed-editor = {
    enable = true;
    package = zedWithCli;

    # Tools used by language servers and formatters must be visible to Zed
    # even when it is launched from the desktop rather than a terminal.
    extraPackages = with pkgs; [
      alejandra
      nixd
      prettier
      eslint
    ];

    extensions = [
      "material-icon-theme"
      "nix"
      "tokyo-night"
    ];

    userSettings = {
      # Keep Zed focused on editing: remove the Agent panel, Threads sidebar,
      # edit predictions, and other built-in AI features.
      disable_ai = true;

      # Show the workspace's directory tree in the conventional left sidebar.
      project_panel = {
        button = true;
        dock = "left";
        default_width = 280;
      };

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

      languages =
        builtins.listToAttrs (map (language: {
            name = language;
            value.formatter.external = {
              command = "prettier";
              arguments = ["--stdin-filepath" "{buffer_path}"];
            };
          })
          prettierLanguages)
        // {
          Nix = {
            # The Nix extension enables nil by default. Prefer nixd and
            # explicitly disable nil instead of merely changing server order.
            language_servers = [
              "nixd"
              "!nil"
            ];
            formatter.external = {
              command = "alejandra";
              arguments = [];
            };
          };
        };

      lsp.nixd.settings.nixd = {
        formatting.command = ["alejandra"];

        # Evaluate the active flake so completion includes options from NixOS,
        # Home Manager, and imported modules such as Noctalia.
        nixpkgs.expr = ''
          import (builtins.getFlake "/home/suezhoo/nixos-config").inputs.nixpkgs-unstable { }
        '';
        options = {
          nixos.expr = ''
            (builtins.getFlake "/home/suezhoo/nixos-config").nixosConfigurations.moonine.options
          '';
          home-manager.expr = ''
            (builtins.getFlake "/home/suezhoo/nixos-config").nixosConfigurations.moonine.options.home-manager.users.type.getSubOptions [ ]
          '';
        };
      };
    };
  };
}
