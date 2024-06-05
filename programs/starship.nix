{ config, lib, pkgs, ... }:

{

  programs.starship = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      add_newline = false;
      scan_timeout = 10;
      format = lib.concatStrings [
        "$username"
        "$hostname"
        " "
        "$directory"
        "$git_branch"
        "$git_commit"
        "$git_status"
        "$character"
      ];
      right_format = lib.concatStrings [
        "$kubernetes"
        "$aws"
      ];
      username = {
        disabled = false;
        show_always = true;
        style_user = "bold blue";
        format = "[$user]($style)";
      };
      hostname = {
        disabled = false;
        ssh_only = true;
        style = "gray";
        format = "@[$hostname]($style)";
      };
      directory = {
        disabled = false;
        fish_style_pwd_dir_length = 2;
      };
      kubernetes = {
        disabled = false;
        format = "'[$symbol$context( \($namespace\))]($style)'";
        detect_env_vars = [
          "KUBECONFIG"
        ];
      };
      git_branch = {
        disabled = false;
      };
      git_commit = {
        disabled = false;
      };
      git_status = {
        disabled = false;
      };
      aws = {
        disabled = true;
        region_aliases = {
          eu-central-1 = "eu-c-1";
        };
      };
      character = {
        disabled = false;
      };
    };
  };

}
