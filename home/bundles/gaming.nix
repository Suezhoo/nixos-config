{
  config,
  lib,
  pkgs,
  ...
}: let
  benchmarkDirectory = "${config.home.homeDirectory}/Benchmarks/MangoHud";
in {
  home.packages = with pkgs; [
    deadlock-mod-manager
  ];

  # Keep the overlay opt-in so it has zero cost outside benchmark runs. With
  # `gamemoderun mangohud %command%`, Shift+F2 starts/stops a CSV capture in
  # ~/Benchmarks/MangoHud for comparing average FPS, 1% lows, and frametimes.
  programs.mangohud = {
    enable = true;
    settings = {
      output_folder = benchmarkDirectory;
      benchmark_percentiles = [
        97
        "AVG"
        1
        "0.1"
      ];
      fps = true;
      frame_timing = true;
      gpu_stats = true;
      gpu_temp = true;
      gpu_power = true;
      cpu_stats = true;
      cpu_temp = true;
      ram = true;
      vram = true;
      wine = true;
      engine_version = true;
      gamemode = true;
      position = "top-left";
    };
  };

  # MangoHud will write logs only when output_folder already exists.
  home.activation.createMangoHudBenchmarkDirectory =
    lib.hm.dag.entryAfter ["writeBoundary"] ''
      run ${pkgs.coreutils}/bin/mkdir -p ${lib.escapeShellArg benchmarkDirectory}
    '';
}
