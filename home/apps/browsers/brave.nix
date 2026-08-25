{...}: {
  programs.brave = {
    enable = true;

    extensions = [
      {id = "ammjkodgmmoknidbanneddgankgfejfh";} # 7TV
    ];

    commandLineArgs = [
      "--enable-features=AcceleratedVideoDecodeLinuxGL,VaapiOnNvidiaGPUs"
      "--use-gl=angle"
      "--use-angle=gl"
    ];
  };
}
