{pkgs, ...}:
{
    programs.vscode = {
        enable = true;

        # Use VSCodium instead of VS Code
        package = pkgs.vscodium;

         # Keep extensions managed by Home-Manager (immutable on disk)
        mutableExtensionsDir = false;

        # Turn off telemetry/update pings (since Nix manages versions)
        enableTelemetry = false;
        enableUpdateCheck = false;

        # Extensions from nixpkgs' Open VSX set:
        extensions = with pkgs.vscode-extensions; [
            dracula-theme
        ]
    }
}