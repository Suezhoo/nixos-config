{pkgs-unstable, ...}: {
  # Install Vesktop alongside official Discord with Vencord injected.
  # Each client keeps its own profile in the normal writable config directory.
  home.packages = with pkgs-unstable; [
    vesktop
    (discord.override {
      withVencord = true;
    })
  ];
}
