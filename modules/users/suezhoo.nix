{...}: {
  users.groups.Suezhoo = {};
  users.users.suezhoo = {
    isNormalUser = true;
    group = "Suezhoo";
    extraGroups = ["wheel" "networkmanager" "video" "audio" "input"];
  };
}
