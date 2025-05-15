{ config, pkgs, ... }:

{

  programs.zsh = {
    enable = true;

    defaultKeymap = "emacs";

    enableCompletion = true;
    autocd = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    historySubstringSearch.enable = true;

    history = {
      size = 100000;
      save = 100000;
      share = true;
      path = "$HOME/.zsh_history";
    };

    shellAliases = {
      feh = "feh -g 1024x768 ";
      sc = "sudo systemctl";
      sj = "sudo journalctl";
      more = "less";
      d = "dirs -v";

      k = "kubectl";
      kl = "export KUBECONFIG=$(pwd)/kubeconfig";
      tl = "export TALOSCONFIG=$(pwd)/talosconfig";
      hm = "home-manager";

      l = "ls -l --color=auto";
      ls = "ls -C --color=auto";
      la = "ls -la --color=auto";
      lh = "ls -hAl --color=auto";
      lsbig = "ls -flh *(.OL[1,10])";

      htpasswd = "docker run --rm alpine sh -c 'apk add pwgen apache2-utils && export pw=`pwgen -B 32 -N 1 -1` && echo \"# $pw\" && htpasswd -nbB username $pw'";

      insecscp = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
      insecssh = "ssh -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null";
    };

    initExtra = ''
      autoload -Uz add-zsh-hook

      # rehash completion when being signalled SIGUSR1
      TRAPUSR1() {
        rehash
      }

      # ring bell whenever shell is ready
      prompt_ringbell_precmd() {
        echo -e '\a\c'
      }
      add-zsh-hook precmd prompt_ringbell_precmd

      # menu style completion
      zstyle ':completion:*' menu select

      # completion of sudo commands
      zstyle ':completion::complete:*' gain-privileges 1

      # persistent dirstack
      DIRSTACKFILE="$HOME/.zdirs"
      DIRSTACKSIZE=20
      setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
      typeset -gaU PERSISTENT_DIRSTACK
      function chpwd () {
        (( ZSH_SUBSHELL )) && return
        (( $DIRSTACKSIZE <= 0 )) && return
        [[ -z $DIRSTACKFILE ]] && return
        PERSISTENT_DIRSTACK=(
            $PWD "''${(@)PERSISTENT_DIRSTACK[1,$DIRSTACKSIZE]}"
        )
        builtin print -l ''${PERSISTENT_DIRSTACK} >! ''${DIRSTACKFILE}
      }
      if [[ -f ''${DIRSTACKFILE} ]]; then
        dirstack=( ''${(f)"$(< $DIRSTACKFILE)"}(N) )
        [[ -d $dirstack[1] ]] && cd -q $dirstack[1] && cd -q $OLDPWD
      fi
      PERSISTENT_DIRSTACK=( "''${dirstack[@]}" )

      # mkdir+cd temporary
      function cdt () {
        builtin cd "$(mktemp -d)"
        builtin pwd
      }

      # delete a word to the left considering '/' a word separator (alt+v)
      function slash-backward-kill-word () {
          local WORDCHARS="''${WORDCHARS:s@/@}"
          # zle backward-word
          zle backward-kill-word
      }
      zle -N slash-backward-kill-word
      bindkey -M "emacs" "\ev" "slash-backward-kill-word"

      # Create directory under cursor (ctrl+x-M)
      function inplaceMkDirs () {
          # Press ctrl-xM to create the directory under the cursor or the selected area.
          # To select an area press ctrl-@ or ctrl-space and use the cursor.
          # Use case: you type "mv abc ~/testa/testb/testc/" and remember that the
          # directory does not exist yet -> press ctrl-XM and problem solved
          local PATHTOMKDIR
          if ((REGION_ACTIVE==1)); then
              local F=$MARK T=$CURSOR
              if [[ $F -gt $T ]]; then
                  F=''${CURSOR}
                  T=''${MARK}
              fi
              # get marked area from buffer and eliminate whitespace
              PATHTOMKDIR=''${BUFFER[F+1,T]%%[[:space:]]##}
              PATHTOMKDIR=''${PATHTOMKDIR##[[:space:]]##}
          else
              local bufwords iword
              bufwords=(''${(z)LBUFFER})
              iword=''${#bufwords}
              bufwords=(''${(z)BUFFER})
              PATHTOMKDIR="''${(Q)bufwords[iword]}"
          fi
          [[ -z "''${PATHTOMKDIR}" ]] && return 1
          PATHTOMKDIR=''${~PATHTOMKDIR}
          if [[ -e "''${PATHTOMKDIR}" ]]; then
              zle -M " path already exists, doing nothing"
          else
              zle -M "$(mkdir -p -v "''${PATHTOMKDIR}")"
              zle end-of-line
          fi
      }
      zle -N inplaceMkDirs
      bindkey -M "emacs" "^xM" "inplaceMkDirs"

      # edit current command line in EDITOR (alt+e)
      autoload -z edit-command-line
      zle -N edit-command-line
      bindkey -M "emacs" "\ee" "edit-command-line"

      # missing key support (pos1, end, del)
      bindkey "^[[H" beginning-of-line
      bindkey "^[[F" end-of-line
      bindkey "^[[3~" delete-char

      # word jumping (ctrl+<left|right>)
      bindkey "^[[1;5C" forward-word
      bindkey "^[[1;5D" backward-word

      # set those so history-substring-search won't show dups
      setopt HIST_IGNORE_DUPS HIST_FIND_NO_DUPS

      # use alacritty window id as gardenctl session
      # this isolates gardenctl scopes to the current terminal
      export GCTL_SESSION_ID="$ALACRITTY_WINDOW_ID"

      # starship prompt
      eval $(starship init zsh)
    '';

    loginExtra = ''
      # essential env vars
      export $(systemctl --user show-environment)
      export PATH=$PATH:$HOME/.nix-profile/bin
      source ~/.nix-profile/etc/profile.d/hm-session-vars.sh

      # autostart sway on login to tty1
      if [[ -z $DISPLAY && "$TTY" == "/dev/tty1" ]]; then
          systemd-cat -t sway sway
          systemctl --user stop sway-session.target
          systemctl --user unset-environment DISPLAY WAYLAND_DISPLAY SWAYSOCK
      fi
    '';
  };

}
