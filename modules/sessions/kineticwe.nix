{
  inputs,
  pkgs,
  ...
}: let
  system = pkgs.stdenv.hostPlatform.system;
  upstream = inputs.kineticwe.packages.${system};

  # Upstream currently publishes its KDecoration source with lib.fakeHash.
  # Preserve the source and revision chosen by KineticWE; only replace that
  # placeholder with the content hash reported by Nix.
  kdecoration = upstream.kdecoration.overrideAttrs (old: {
    src = old.src.overrideAttrs (_: {
      outputHash = "sha256-4oqhnoVQjVWtqIurZQ3qCjRy3UCdNBjEJNDk8jaUz6Q=";
    });
    # KDecoration is a library and does not install an application to wrap.
    dontWrapQtApps = true;
  });

  kwin-we = upstream."kwin-we".override {
    kdecorationGit = kdecoration;
  };

  session = upstream.session.override {
    kwinWe = kwin-we;
  };
in {
  # Mirror upstream's module integration with the corrected package chain.
  nixpkgs.overlays = [
    (_final: _prev: {
      kineticwe = session;
      inherit kdecoration;
      "kwin-we" = kwin-we;
      kglobalacceld = upstream.kglobalacceld;
      noctalia = upstream.noctalia;
    })
  ];

  environment.systemPackages = [
    session
    kwin-we
    kdecoration
    upstream.kglobalacceld
    upstream.noctalia
  ];

  services.displayManager.sessionPackages = [session];

  xdg.portal = {
    enable = true;
    extraPortals = [pkgs.kdePackages.xdg-desktop-portal-kde];
    config.common.default = ["kde"];
  };
}
