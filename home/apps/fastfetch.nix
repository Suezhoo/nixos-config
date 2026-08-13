{...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      logo = {
        source = "nixos_small";
        padding.right = 3;
      };

      display = {
        separator = " ➜ ";

        color = {
          keys = "cyan";
          title = "green";
        };
      };

      modules = [
        "title"
        "separator"

        {
          type = "os";
          key = "OS";
        }

        {
          type = "kernel";
          key = "├ Kernel";
        }

        {
          type = "uptime";
          key = "└ Uptime";
        }

        "break"

        {
          type = "command";
          key = "PC";
          text = "hostname";
        }

        {
          type = "cpu";
          key = "├ CPU";
        }

        {
          type = "gpu";
          key = "├ GPU";
        }

        {
          type = "memory";
          key = "├ Memory";
        }

        {
          type = "display";
          key = "├ Display";
        }

        {
          type = "disk";
          key = "└ Disk";
          folders = "/";
        }

        "break"

        {
          type = "wm";
          key = "WM";
        }

        {
          type = "de";
          key = "├ DE";
        }

        {
          type = "terminal";
          key = "├ Terminal";
        }

        {
          type = "shell";
          key = "├ Shell";
        }

        {
          type = "terminalfont";
          key = "└ Font";
        }

        "break"
      ];
    };
  };
}
