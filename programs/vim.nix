{ config, pkgs, ... }:

{

  programs.vim = {
    enable = true;

    defaultEditor = true;

    settings = {
      background = "dark";
      expandtab = true;
      tabstop = 2;
      shiftwidth = 4;
      undodir = ["$HOME/.vim/undodir"];
      undofile = true;
      mouse = "a";
      number = true;
    };

    extraConfig = ''
      set nocompatible
      set nobackup
      filetype off
      set autoindent
    '';

  };

}
