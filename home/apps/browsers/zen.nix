{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    # Reproducible Zen release supplied by the community-maintained flake.
    inputs.zen-browser.packages.${pkgs.stdenv.hostPlatform.system}.twilight
  ];
}
