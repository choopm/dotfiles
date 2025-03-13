{ config, pkgs, lib, ... }:

{
  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "vscode"
  ];

  programs.vscode = {
    enable = true;

    userSettings = {
      "telemetry.telemetryLevel" = "off";
      "diffEditor.ignoreTrimWhitespace" = false;
      "editor.rulers" = [{
        "column" = 80;
      }];
      "editor.codeActionsOnSave" = {
        "source.fixAll" = "explicit";
        "source.organizeImports" = "explicit";
      };
      "extensions.ignoreRecommendations" = true;
      "explorer.confirmDelete" = false;
      "files.insertFinalNewline" = true;
      "files.trimFinalNewlines" = true;
      "files.trimTrailingWhitespace" = true;
      "go.useLanguageServer" = true;
      "go.toolsManagement.autoUpdate" = true;
      "go.toolsManagement.checkForUpdates" = "local";
      "go.formatTool" = "gofmt";
      "[go]" = {
        "editor.insertSpaces" = false;
        "editor.formatOnSave" = true;
        "editor.codeActionsOnSave" = {
          "source.organizeImports" = "explicit";
        };
      };
      "[javascript]" = {
        "editor.defaultFormatter" = "vscode.typescript-language-features";
      };
      "[json]" = {
        "editor.defaultFormatter" = "vscode.json-language-features";
      };
      "nix.enableLanguageServer" = true;
      "nix.serverPath" = "nixd";
      "nix.formatterPath" = "nixpkgs-fmt";
      "terminal.integrated.fontFamily" = "Meslo LG S DZ for Powerline";
      "terminal.integrated.scrollback" = 10000;
      "remote.autoForwardPortsSource" = "hybrid";
      "workbench.editorAssociations" = {
        "*.pdf" = "default";
      };
      "workbench.startupEditor" = "none";
      "workbench.quickOpen.preserveInput" = true;
      "chat.commandCenter.enabled" = false;
    };
  };

}
