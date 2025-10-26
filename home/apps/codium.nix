{pkgs, ...}: {
  programs.vscode = {
    enable = true;

    # Use VSCodium instead of VS Code
    package = pkgs.vscodium;

    # Keep extensions managed by Home-Manager (immutable on disk)
    mutableExtensionsDir = false;

    # Extensions from nixpkgs' Open VSX set:
    extensions = with pkgs.vscode-extensions; [
      # Nix support
      bbenoist.nix
      jnoortheen.nix-ide

      # Appearance
      pkief.material-icon-theme
      enkia.tokyo-night

      # Formatter
      esbenp.prettier-vscode

      # ESLint
      dbaeumer.vscode-eslint
    ];

    userSettings = {
      "workbench.colorTheme" = "Tokyo Night";
      "workbench.iconTheme" = "material-icon-theme";

      # Nix IDE
      "[nix]" = {
        "editor.defaultFormatter" = "jnoortheen.nix-ide";
        "editor.formatOnSave" = true;
      };

      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nil";
      "nix.serverSettings" = {
        "nil" = {
          "formatting" = {
            "command" = ["alejandra"];
          };
        };
      };

      # Prettier Formatter
      "editor.defaultFormatter" = "esbenp.prettier-vscode";
      "editor.formatOnSave" = true;
      "prettier.requireConfig" = true;
    };
  };
}
