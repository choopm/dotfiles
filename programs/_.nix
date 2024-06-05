{ config, pkgs, ... }:

{

  imports = [
    ./alacritty.nix
    ./git.nix
    ./ssh.nix
    ./starship.nix
    ./vim.nix
    ./vscode.nix
    ./wofi.nix
    ./zsh.nix
  ];

}
