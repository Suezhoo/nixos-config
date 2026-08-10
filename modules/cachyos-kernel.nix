{
  inputs,
  pkgs,
  ...
}: {
  # Persist the upstream project's cache configuration for future rebuilds.
  nix.settings = {
    extra-substituters = ["https://attic.xuyh0120.win/lantian"];
    extra-trusted-public-keys = [
      "lantian:EeAUQ+W+6r7EtwnmYjeVwx5kOGEBpjlBfPlzGlTNvHc="
    ];
  };

  # Use the package set pinned by nix-cachyos-kernel so the prebuilt kernel
  # matches the patches and cache published by that project.
  nixpkgs.overlays = [inputs.nix-cachyos-kernel.overlays.pinned];

  # This changes only the kernel package set. The rest of the system remains
  # an ordinary declarative NixOS configuration with generations and rollback.
  boot.kernelPackages =
    pkgs.cachyosKernels.linuxPackages-cachyos-latest;
}
