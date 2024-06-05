{ config, pkgs, ... }:

{
  home.username = "ubuntu";
  home.homeDirectory = "/home/ubuntu";

  targets.genericLinux.enable = true;

  home.stateVersion = "24.05";

  home.packages = [
    pkgs.nixd
  ];

  home.file = {
  };

  home.sessionVariables = {
    COLORTERM="yes";
    PAGER = "less -Mr";

    GOPRIVATE = "github.com";

    PATH = "$PATH:$HOME/.nix-profile/bin";
  };

  programs.home-manager.enable = true;

  imports = [
    ../programs/starship.nix
    ../programs/vim.nix
    ../programs/zsh.nix
  ];

}
