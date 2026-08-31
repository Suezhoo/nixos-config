{pkgs, ...}: let
  rider = pkgs.symlinkJoin {
    name = "rider-with-libstdcxx";
    paths = [pkgs.jetbrains.rider];

    nativeBuildInputs = [pkgs.makeWrapper];

    postBuild = ''
      wrapProgram $out/bin/rider \
        --prefix LD_LIBRARY_PATH : ${
          pkgs.lib.makeLibraryPath [pkgs.stdenv.cc.cc.lib]
        }
    '';
  };
in {
  home.packages = [rider];
}
