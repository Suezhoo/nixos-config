{
  config,
  lib,
  ...
}: {
  # Ensure mountpoint exists
  systemd.tmpfiles.rules = ["d /mnt/windows 0755 root root -"];

  # Mount Windows C: by UUID (from lsblk)
  fileSystems."/mnt/windows" = {
    device = "/dev/disk/by-uuid/2E464C06464BCD71";
    fsType = "ntfs3";
    options = [
      "uid=1000" # adjust if your UID differs (check with: id -u)
      "gid=988" # adjust if your primary GID differs (id -g)
      "umask=022"
      "windows_names"
      "nofail" # don't block boot if disk is missing
      "rw"
    ];
  };
}
