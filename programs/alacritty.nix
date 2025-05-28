{ config, pkgs, ... }:

{

  programs.alacritty = {
    enable = true;

    settings = {
      colors.normal = {
        black = "#000000";
        blue = "#0000ff";
        cyan = "#aaaaaa";
        green = "#00aa00";
        magenta = "#00aaaa";
        red = "#ff5555";
        white = "#ffffff";
        yellow = "#aa5500";
      };

      colors.primary = {
        background = "#131313";
        foreground = "#209bd7";
      };

      font = {
        size = 10.0;
        normal.family = "Meslo LG S DZ for Powerline";
      };

      mouse.hide_when_typing = true;
      scrolling.history = 100000;

      window = {
        opacity = 0.9;
        dynamic_title = true;

        dimensions = {
          columns = 85;
          lines = 25;
        };
      };
    };
  };

}
