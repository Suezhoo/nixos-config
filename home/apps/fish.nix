{...}: {
  programs.fish = {
    enable = true;

    shellAliases = {
      rebuild = "sudo nixos-rebuild switch --flake ~/nixos-config#moonine";
      ff = "clear && fastfetch";
    };

    # Start each interactive shell without Fish's default greeting.
    interactiveShellInit = ''
      set fish_greeting
    '';
  };
}
