{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  home.packages = [
    pkgs.xclip
    pkgs.oh-my-zsh
    pkgs.zsh-autosuggestions
    pkgs.zsh-fast-syntax-highlighting
    pkgs.zsh-autopair
    pkgs.zsh-you-should-use
  ];

  home.sessionVariables = {
    # ZSH_AUTOSUGGEST_USE_ASYNC = "on";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=12";
    COPY_COMMAND = "xc";
    KEYTIMEOUT = "10";
  };

  programs.zsh = let
    omzp = name: {
      inherit name;
      src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${name}";
    };
    omzl = name: file: {
      inherit name file;
      src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/";
    };
  in {
    enableAutosuggestions = true;
    enableVteIntegration = true;

    plugins = [
      {
        file = "fast-syntax-highlighting.plugin.zsh";
        name = "zsh-fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/";
      }
      {
        name = "you-should-use";
        src = "${pkgs.zsh-you-should-use}/share/zsh/plugins/you-should-use/";
      }
      {
        name = "zsh-selections";
        file = "selections.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "e-nikolov";
          repo = "zsh-selections";
          rev = "v0.1.0";
          sha256 = "sha256-31XeHmOj/0bpeR7OxIZzGt81PZAuNHmLafd15+DduG8=";
        };
      }
      {
        file = "autopair.zsh";
        name = "zsh-autopair";
        src = "${pkgs.zsh-autopair}/share/zsh/zsh-autopair/";
      }
      {
        name = "kubectl-aliases";
        file = ".kubectl_aliases";
        src = pkgs.fetchFromGitHub {
          owner = "ahmetb";
          repo = "kubectl-aliases";
          rev = "b2ee5dbd3d03717a596d69ee3f6dc6de8b140128";
          sha256 = "sha256-TCk26Wdo35uKyTjcpFLHl5StQOOmOXHuMq4L13EPp0U=";
        };
      }
      {
        name = "git-it-on";
        file = "git-it-on.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "peterhurford";
          repo = "git-it-on.zsh";
          rev = "6495b09d3bf60a103f45e1e39ce904ae3cf18cf0";
          sha256 = "sha256-++DIZ9+/FkYkuxlGFRVxTl31n7ExngJ/RlLNqo4UAFk=";
        };
      }
      {
        name = "zsh-tab-title";
        file = "zsh-tab-title.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "trystan2k";
          repo = "zsh-tab-title";
          rev = "3b247abde7a7e776833423f5316d357952450025";
          sha256 = "sha256-bSj2172LVXUPLE9YEQoNWIkCck3TbuVYXL5u3uySeZY=";
        };
      }
      (omzp "sudo")
      (omzl "functions" "functions.zsh")
      (omzp "web-search")
      (omzp "dirhistory")
      (omzp "golang")
      (omzl "git-lib" "git.zsh")
      (omzp "git")
      (omzp "colored-man-pages")
      # (omzp "ssh-agent")
    ];

    initExtra = ''
      if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        xc() {
            wl-copy
        }
      elif command -v xclip &> /dev/null; then
        xc() {
            xclip -selection clipboard
        }
      elif command -v pbcopy &> /dev/null; then
        xc() {
            pbcopy
        }
      else
        xc() {
            echo "No clipboard command found"
        }
      fi

      ### Functions ###
      WORDCHARS="*?_-[]~=&;!$%^(){}<>"
      STATEMENTCHARS="@\,:\"'~=!#$%^&*?+_-/;."
      # STATEMENTCHARS="@\,:\"'~=!#$%^&*?+_-/;.(){}[]<>"

      backward-delete-statement () {
          local WORDCHARS=$STATEMENTCHARS
          zle backward-delete-word
      }
      zle -N backward-delete-statement

      kill-statement () {
          local WORDCHARS=$STATEMENTCHARS
          zle kill-word
      }
      zle -N kill-statement

      backward-statement () {
          local WORDCHARS=$STATEMENTCHARS
          zle emacs-backward-word
      }
      zle -N backward-statement

      forward-statement () {
          local WORDCHARS=$STATEMENTCHARS
          zle emacs-forward-word
      }
      zle -N forward-statement

      ### Key binds ###
        # bindkey '^[[H' beginning-of-line
        # bindkey '^[[F' end-of-line
        # bindkey '^[]Z' redo

      # Alt+Backspace
      bindkey '^[^?' backward-delete-statement

      # Alt+Delete
      bindkey '^[[3;3~' kill-statement
      bindkey '^H' backward-kill-word

      autoload -U select-word-style
      select-word-style bash

      # Ctrl+Alt+LeftArrow
      bindkey "^[[1;7D" dirhistory_zle_dirhistory_back
      # Ctrl+Alt+RightArrow
      bindkey "^[[1;7C" dirhistory_zle_dirhistory_future
      # bindkey "^[[1;7C" dirhistory_zle_dirhistory_up
      # bindkey "^[[1;7C" dirhistory_zle_dirhistory_down

      export ACTION_SELECT_BACKWARD_STATEMENT=$'^[[1;8D'
      export ACTION_SELECT_FORWARD_STATEMENT=$'^[[1;8C'

      export ACTION_UNSELECT_FORWARD_STATEMENT=$'^[[1;3C'
      export ACTION_UNSELECT_BACKWARD_STATEMENT=$'^[[1;3D'

      function widget::action-select-forward-statement() {
          widget::util-select forward-statement $@
      }
      zle -N widget::action-select-forward-statement
      function widget::action-select-backward-statement() {
          widget::util-select backward-statement $@
      }
      zle -N widget::action-select-backward-statement
      function widget::action-unselect-forward-statement() {
          widget::util-unselect forward-statement $@
      }
      zle -N widget::action-unselect-forward-statement
      function widget::action-unselect-backward-statement() {
          widget::util-unselect backward-statement $@
      }
      zle -N widget::action-unselect-backward-statement


      bindkey $ACTION_SELECT_FORWARD_STATEMENT widget::action-select-forward-statement
      bindkey $ACTION_SELECT_BACKWARD_STATEMENT widget::action-select-backward-statement
      bindkey $ACTION_UNSELECT_FORWARD_STATEMENT widget::action-unselect-forward-statement
      bindkey $ACTION_UNSELECT_BACKWARD_STATEMENT widget::action-unselect-backward-statement

      ### Aliases ###

      export ZSH_WEB_SEARCH_ENGINES=(nixpkgs "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=")
      export ZSH_AUTOSUGGEST_USE_ASYNC=on
    '';
  };
}
