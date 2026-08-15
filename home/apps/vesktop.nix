{pkgs-unstable, ...}: {
  # Vesktop keeps its profile in the normal writable Linux config directory.
  # Do not link or migrate state from the Windows installation.
  home.packages = with pkgs-unstable; [
    vesktop
    discord
  ];
}
