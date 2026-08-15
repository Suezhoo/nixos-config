{pkgs, ...}: {
  home.packages = with pkgs; [
    # Video and motion
    davinci-resolve # Professional video editing, colour grading, effects, and audio post-production.
    kdePackages.kdenlive # Linux-native video editor and reliable fallback for unsupported Resolve formats.
    blender # 3D modelling, animation, rendering, compositing, and motion graphics.

    # Raster, illustration, and vector graphics
    gimp # Photo editing, image manipulation, and general raster graphics.
    krita # Digital painting, drawing, illustration, and frame-by-frame animation.
    inkscape # Vector graphics for logos, icons, diagrams, and scalable artwork.

    # Audio editing
    audacity # Record, trim, clean up, and process audio or voice clips.

    # Media inspection and command-line conversion
    ffmpeg-full # Convert, encode, remux, and process nearly any audio or video format.
    imagemagick # Convert, resize, crop, and batch-process images from the command line.
    mediainfo # Display detailed codec, resolution, bitrate, and track information for media files.
  ];
}
