{ ... }: {
  programs.alacritty = {
    enable = true;

    settings = {
      env = {
        TERM = "xterm-256color";
      };

      window = {
        opacity = 1.0;
        padding = { x = 6; y = 6; };
        dynamic_padding = false;
        decorations = "none"; # minimal UI
      };

      font = {
        normal = {
          family = "BlexMono Nerd Font";
          style = "Regular";
        };
        bold = {
          family = "BlexMono Nerd Font";
          style = "Bold";
        };
        size = 12.5;
        offset = { x = 0; y = 1; };
      };
	
      mouse = { hide_when_typing = true; };

      colors = {
        primary = {
          background = "#0f1112"; # Matte Black Steel
          foreground = "#c0c0c0"; # Gunmetal Silver
        };

        cursor = {
          text = "CellBackground";
          cursor = "#ffcc00"; # Amber Torch
        };

        hints = {
          start = {
            foreground = "#1e1e2e";
            background = "#f9e2af";
          };
          end = {
            foreground = "#1e1e2e";
            background = "#a6adc8";
          };
        };

        normal = {
          black   = "#0f1112";  # same as background
          red     = "#ff0033";  # Industrial Red
          green   = "#33ff00";  # Toxic Green
          yellow  = "#ffcc00";  # Amber
          blue    = "#00aaff";  # Arc Weld Blue
          magenta = "#cc66ff";  # UV Plasma
          cyan    = "#00ffcc";  # Hacker Cyan
          white   = "#f5f5f5";  # Ash White
        };

        bright = {
          black   = "#1a1c1e";
          red     = "#ff3344";
          green   = "#66ff33";
          yellow  = "#ffee00";
          blue    = "#33ccff";
          magenta = "#dd88ff";
          cyan    = "#66ffe0";
          white   = "#ffffff";
        };
      };

      cursor.style = "Block";

      scrolling = {
        history = 10000;
        multiplier = 3;
      };
    };
  };
}

