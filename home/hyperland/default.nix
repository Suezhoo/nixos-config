{pkgs, ...}: {
  # Tools inside hyprland
  home.packages = with pkgs; [
    waybar # top bar
    wofi # app launcher

    # other
    grim
    slurp
    wl-clipboard
    brightnessctl
    pavucontrol
  ];
}
