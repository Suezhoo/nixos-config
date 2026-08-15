{pkgs, ...}: {
  programs.fish.enable = true;

  users.groups.Suezhoo = {};
  users.users.suezhoo = {
    isNormalUser = true;
    group = "Suezhoo";
    shell = pkgs.fish;
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input" "docker"];
  };
}
