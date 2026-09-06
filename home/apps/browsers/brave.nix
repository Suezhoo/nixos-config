{...}: {
  programs.brave = {
    enable = true;

    extensions = [
      {id = "ammjkodgmmoknidbanneddgankgfejfh";} # 7TV
    ];

    commandLineArgs = [
      # Chromium does not reliably consume the portal preference on every
      # non-GNOME desktop.  Keep its native UI and web preference dark.
      "--force-dark-mode"
      "--enable-features=AcceleratedVideoDecodeLinuxGL,VaapiOnNvidiaGPUs"
      "--use-gl=angle"
      "--use-angle=gl"
    ];
  };
}
