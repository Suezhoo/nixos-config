{
  config,
  lib,
  pkgs,
  ...
}: let
  # CHANGE THIS to your Windows username
  windowsUser = "Suezhoo";

  # Path to the Windows Vencord directory (mounted NTFS)
  winVencord = "/mnt/windows/Users/${windowsUser}/AppData/Roaming/Vencord";

  cfgHome = config.xdg.configHome or (config.home.homeDirectory + "/.config");
in {
  # Install Vesktop (ships with Vencord)
  home.packages = [pkgs.vesktop];

  # Soft, idempotent linking at activation time (doesn't fail if /mnt/windows isn't there)
  home.activation.linkVencord = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if [ -d "${winVencord}" ]; then
      mkdir -p "${cfgHome}"

      # Link ~/.config/Vencord -> Windows Vencord
      if [ -L "${cfgHome}/Vencord" ] || [ -d "${cfgHome}/Vencord" ]; then
        rm -rf "${cfgHome}/Vencord"
      fi
      ln -s "${winVencord}" "${cfgHome}/Vencord"

      # Optional: also expose it as ~/.config/vesktop for convenience
      if [ -e "${cfgHome}/vesktop" ] && [ ! -L "${cfgHome}/vesktop" ]; then
        # if a real dir/file exists, don't clobber it
        echo "Skipping ~/.config/vesktop: exists and is not a symlink."
      else
        rm -f "${cfgHome}/vesktop"
        ln -s "${cfgHome}/Vencord" "${cfgHome}/vesktop"
      fi

      echo "Linked Vencord from Windows → ${cfgHome}/Vencord"
    else
      echo "Warning: ${winVencord} not found; is /mnt/windows mounted and user correct?"
      echo "Skipping Vencord symlink; Vesktop will use its local config."
    fi
  '';
}
