{
  inputs,
  pkgs,
  ...
}: let
  upstream = inputs.kineticwe.packages.${pkgs.stdenv.hostPlatform.system};

  # Upstream intentionally ships a fake hash for this pinned source and asks
  # first-time builders to replace it with the hash reported by Nix. Since a
  # flake input is immutable, apply that documented hash here instead.
  kdecoration = upstream.kdecoration.overrideAttrs (old: {
    src = old.src.overrideAttrs (_: {
      outputHash = "sha256-4oqhnoVQjVWtqIurZQ3qCjRy3UCdNBjEJNDk8jaUz6Q=";
    });
    dontWrapQtApps = true;
  });

  kwin-we =
    (upstream."kwin-we".override {
      kdecorationGit = kdecoration;
    }).overrideAttrs (old: {
      # The session launcher exports KDE_FULL_SESSION before Qt constructs
      # KWin's application. KineticWE's QPA then requests the KDE platform
      # theme, whose early theme-change event crashes Qt 6.11.1. Keep it unset
      # for the compositor; KineticWE's startup payload restores it for apps.
      qtWrapperArgs = (old.qtWrapperArgs or []) ++ [
        "--unset KDE_FULL_SESSION"
      ];
    });

  session = upstream.session.override {
    kwinWe = kwin-we;
  };
in {
  imports = [inputs.kineticwe.nixosModules.default];

  nixpkgs.overlays = [
    (_final: _prev: {
      kineticwe = session;
      inherit kdecoration;
      "kwin-we" = kwin-we;
      kglobalacceld = upstream.kglobalacceld;
      noctalia = upstream.noctalia;
    })
  ];

  programs.kineticwe.enable = true;
}
