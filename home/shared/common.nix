{...}: {
  # Defaults suitable for every Home Manager user in this repository.
  home.stateVersion = "25.05";

  # Shared contract used when a desktop shell integrates with a compositor.
  imports = [../desktop/shell-interface.nix];
}
