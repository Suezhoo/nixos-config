{pkgs, ...}: {
  home.packages = with pkgs; [
    rustdesk # General-purpose remote access: both host and client.
    moonlight-qt # Low-latency client for Sunshine hosts.
  ];
}
