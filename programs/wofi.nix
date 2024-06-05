{ config, pkgs, ... }:

{

  programs.wofi = {
    enable = true;

    settings = {
      allow_images = true;
      insensitiv = true;
      no_actions = true;
      columns = 2;
      show = "drun";
    };

    # dracula.css
    style = ''
      window {
        margin: 0px;
        border: 1px solid #bd93f9;
        background-color: #282a36;
      }

      #input {
        margin: 5px;
        border: none;
        background-color: #44475a;
      }

      #inner-box {
        margin: 5px;
        border: none;
        background-color: #282a36;
      }

      #outer-box {
        margin: 5px;
        border: none;
        background-color: #282a36;
      }

      #scroll {
        margin: 0px;
        border: none;
      }

      #text {
        margin: 5px;
        border: none;
        color: #ffffff;
      }

      #entry:selected {
        background-color: #44475a;
      }
    '';

  };

}
