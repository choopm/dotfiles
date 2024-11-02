{ config, pkgs, ... }:

{

  programs.git = {
    enable = true;
    userName = "Christoph Hoopmann";
    userEmail = "choopm@0pointer.org";
    aliases = {
      co = "checkout";
      ci = "commit";
      st = "status -sb";
      br = "branch";
      hist = "log --pretty=format:\"%C(auto)%h %ad | %s%d [%an]\" --graph --date=short";
      stat = "shortlog -sne --no-merges";
    };
    extraConfig = {
      core = {
        autocrlf = "input";
        safecrlf = false;
        whitespace = "trailing-space,space-before-tab";
      };
      push = {
        default = "simple";
      };
      pull = {
        rebase = false;
      };
      merge = {
        tool = "vimdiff";
      };
      diff = {
        tool = "vimdiff";
      };
      init = {
        defaultBranch = "main";
      };
      # set outside in ~/.gitconfig using `git config --file=.gitconfig url.https://ghp_xxx@github.com/.insteadOf https://github.com/`
      # url = {
      #   "https://choopm:<ghp_>@github.com/" = {
      #     insteadOf = "https://github.com/";
      #   };
      # };
    };
  };

}
