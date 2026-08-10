{...}: {
  programs.brave = {
    enable = true;

    extensions = [
      {id = "ammjkodgmmoknidbanneddgankgfejfh";} # 7TV
    ];

    commandLineArgs = [
      "--enable-features=AcceleratedVideoDecodeLinuxGL,VaapiOnNvidiaGPUs"
      "--ignore-gpu-blocklist"
      "--use-gl=angle"
      "--use-angle=gl"
      "--enable-zero-copy"
    ];
  };
}
