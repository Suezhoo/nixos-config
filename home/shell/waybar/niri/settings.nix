# returns Waybar settings for Niri
{}: {
  mainBar = {
    layer = "bottom";
    "margin-top" = 10;
    "margin-left" = 10;
    "margin-right" = 10;
    position = "top";
    height = 32;

    modules-left = ["niri/workspaces"];
    modules-center = ["window"]; # generic title module
    modules-right = ["clock"];

    window = {max-length = 80;};

    clock = {
      interval = 1;
      format = "{:%Y-%m-%d | %H:%M:%S}";
      tooltip = true;
      tooltip-format = "{:L%Y %m %d, %A}";
    };
  };
}
