{pkgs, ...}:
{
    programs.vscode = {
        enable = true;

        # Use VSCodium instead of VS Code
        package = pkgs.vscodium;

         # Keep extensions managed by Home-Manager (immutable on disk)
        mutableExtensionsDir = false;

        # Extensions from nixpkgs' Open VSX set:
        extensions = with pkgs.vscode-extensions; [
            dracula-theme.theme-dracula
            bbenoist.nix
            jnoortheen.nix-ide
        ];

        userSettings = {
            "workbench.colorTheme" = "Dracula";

            # Nix IDE
            "nix.enableLanguageServer" = true;
            "nix.serverPath" = "nil";
            "nix.formatterPath" = "nixfmt";

            # Other
            "editor.formatOnSave" = true;
        };
    };
}