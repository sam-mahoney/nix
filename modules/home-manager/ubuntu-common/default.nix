{
  outputs,
  userConfig,
  config,
  pkgs,
  ...
}:
{
  # This file contains my ubuntu WM (i3) config

  # Enable X session for i3
  xsession.enable = true;
  
  # i3 window manager config (as before—customize further)
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3;

    config = {
      modifier = "Mod4";
      terminal = "gnome-terminal";
      menu = "rofi -show drun";

      keybindings = let
        mod = config.xsession.windowManager.i3.config.modifier;
      in {
        "${mod}+Return" = "exec ${config.xsession.windowManager.i3.config.terminal}";
        "${mod}+d" = "exec ${config.xsession.windowManager.i3.config.menu}";
        "${mod}+Shift+q" = "kill";
        "${mod}+Shift+e" = "exec i3-nagbar -t warning -m 'Exit i3?' -b 'Yes' 'i3-msg exit'";
      };

      bars = [
        {
          position = "top";
          statusCommand = "${pkgs.i3status}/bin/i3status";
        }
      ];
    };

    extraConfig = ''
      gaps inner 10
      gaps outer 5
    '';
  };
  
  # Packages for i3 ecosystem
  home.packages = with pkgs; [
    i3status
    rofi
    # Add more: feh, picom, etc.
  ];

}