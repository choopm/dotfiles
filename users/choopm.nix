{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "choopm";
  home.homeDirectory = "/home/choopm";

  targets.genericLinux.enable = true;

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')

    pkgs.nixd
    pkgs.go-task

    (pkgs.writeShellScriptBin "update" (builtins.readFile ../bin/arch-update.sh))
    (pkgs.writeShellScriptBin "autosnap-btrfs-root" (builtins.readFile ../bin/autosnap-btrfs-root.sh))
    (pkgs.writeShellScriptBin "py3status-bt-toggle" (builtins.readFile ../bin/py3status-bt-toggle.sh))
    (pkgs.writeShellScriptBin "htpasswd" (builtins.readFile ../bin/htpasswd.sh))
    (pkgs.writeShellScriptBin "mkrouter" (builtins.readFile ../bin/mkrouter.sh))
    (pkgs.writeShellScriptBin "secureboot-sign" (builtins.readFile ../bin/secureboot-sign.sh))
    (pkgs.writeShellScriptBin "termcolors" (builtins.readFile ../bin/termcolors.sh))
    (pkgs.writeShellScriptBin "usbguard-applet" (builtins.readFile ../bin/usbguard-applet.sh))
    (pkgs.writeShellScriptBin "wayland-scrot" (builtins.readFile ../bin/wayland-scrot.sh))
    (pkgs.writeShellScriptBin "wofi-notes" (builtins.readFile ../bin/wofi-notes.sh))
    (pkgs.writeShellScriptBin "workspace-selector" (builtins.readFile ../bin/workspace-selector.sh))
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';

    ".config/sway".source = ../dotfiles/sway;
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/choopm/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # common
    COLORTERM="yes";
    TERM = "alacritty";
    EDITOR = "vim";
    BROWSER = "chromium";
    # PRINTER = "";
    PAGER = "less -R";

    # xdg
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_CACHE_HOME = "$HOME/.cache";

    # wayland
    MOZ_ENABLE_WAYLAND = "1";
    XDG_CURRENT_DESKTOP = "sway";
    XDG_SESSION_TYPE = "wayland";
    #GDK_BACKEND = "wayland";

    # golang
    GOPATH = "$HOME/.go";
    GOPRIVATE = "github.com";

    # java
    _JAVA_AWT_WM_NONREPARENTING = "1";
    JAVA_HOME = "/usr/lib/jvm/default";

    # adjust paths
    PATH = "$PATH:$HOME/.nix-profile/bin:$GOPATH/bin:$JAVA_HOME";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  # import others
  imports = [
    ../programs/_.nix
  ];

  # services
  services.gpg-agent = {
    enable = true;
    defaultCacheTtl = 1800;
  };

  services.ssh-agent = {
    enable = true;
  };

  services.mako = {
    enable = true;
  };

}
