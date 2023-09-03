{
  config,
  pkgs,
  inputs,
  ...
}: {
  programs.home-manager.enable = true;

  home.packages =
    [
      pkgs.nix
      pkgs.micro
      pkgs.htop
      pkgs.nixfmt
      pkgs.curl
      pkgs.git
      pkgs.ripgrep-all
      pkgs.jq
      pkgs.websocat
      pkgs.rustc
      pkgs.file
      pkgs.tldr
      pkgs.rsync
      pkgs.direnv
      pkgs.rnix-lsp
      pkgs.gnupg
      pkgs.gnumake
      pkgs.bc
      pkgs.xclip
      pkgs.lsof
      pkgs.bash-completion
      pkgs.oh-my-zsh
      pkgs.zsh-fzf-tab
      # pkgs.zsh-z
      pkgs.zsh-autosuggestions
      pkgs.zsh-fast-syntax-highlighting
      pkgs.zsh-powerlevel10k
      pkgs.zsh-autopair
      pkgs.zsh-you-should-use
      pkgs.zsh-completions
      pkgs.meslo-lgs-nf
      pkgs.neofetch
      pkgs.sops
      pkgs.age
      pkgs.xxh
      pkgs.nixos-option
      pkgs.nix-doc

      # pkgs.cachix
      # pkgs.devenv

      # pkgs.comma
      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];
  targets.genericLinux.enable = true;

  programs.fzf.enable = true;
  programs.htop.enable = true;
  programs.yazi.enable = true;
  programs.yazi.enableZshIntegration = true;
  programs.zoxide.enable = true;
  programs.zoxide.enableZshIntegration = true;
  programs.zellij.enable = true;
  programs.zellij.settings = {
    # copy_on_select = false;
    default_layout = "compact";

    keybinds = {
      unbind = ["Alt Left" "Alt Right" "Ctrl 1" "Ctrl 3" "Ctrl 5" "Ctrl 2" "Ctrl h" "Alt ["];
      normal = {
        "bind \"Ctrl 1\"" = {MoveFocusOrTab = "Left";};
        "bind \"Ctrl 3\"" = {MoveFocusOrTab = "Right";};
        "bind \"Ctrl 5\"" = {MoveFocus = "Down";};
        "bind \"Ctrl 2\"" = {MoveFocus = "Up";};
        "bind \"Ctrl e\"" = {SwitchToMode = "Tab";};
        "bind \"Alt t\"" = {NewTab = "";};
        "bind \"Ctrl [\"" = {PreviousSwapLayout = "";};
        "bind \"Ctrl ]\"" = {NextSwapLayout = "";};
      };
    };
  };

  programs.neovim.enable = true;
  programs.neovim.coc.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimdiffAlias = true;
  programs.neovim.withPython3 = true;
  programs.neovim.withNodeJs = true;

  programs.git = {
    enable = true;
    difftastic.enable = true;
    extraConfig = {
      core = {
        editor = "micro";
      };
      credential = {
        helper = "cache --timeout=3600";
      };

      url = {
        "git@github.com:" = {insteadOf = "https://github.com/";};
        "ssh://git@bitbucket.org/" = {insteadOf = "https://bitbucket.org/";};
      };

      pull = {
        ff = "only";
      };
    };
  };

  programs.gitui.enable = true;
  programs.nix-index.enable = true;
  programs.nix-index-database.comma.enable = true;

  programs.exa = {
    enable = true;
  };

  programs.ssh = {
    forwardAgent = true;
    enable = true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  fonts.fontconfig.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.shellAliases = {
    hme = "code ~/nix-config/ ";
    xargs = "xargs ";

    gct = "git commit -am 'tmp'";

    sudo = ''sudo -E env "PATH=$PATH" '';
    ls = "exa -alh --group-directories-first --color always --icons ";
    tree = "exa --tree -alh --group-directories-first --color always --icons ";
    grep = "grep --color --ignore-case --line-number --context=3 ";
    df = "df -h ";

    zfg = "code ~/.zshrc";
    src = "source ~/.zshrc";

    port = "sudo lsof -i -P -n | fzf";
    pp = "ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

    gi = "go install ./...";
    gomt = "go mod tidy";

    d = "docker";
    dc = "docker-compose";
    dcu = "docker-compose up";
    dcr = "docker-compose run";
    dclt = "docker-compose logs --follow --tail=100";

    tf = "terraform";
    x = "xdg-open";
    nixpkgs = "web_search nixpkgs ";
  };

  home.sessionVariables = {
    ZSH_AUTOSUGGEST_USE_ASYNC = "on";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=12";
    EDITOR = "micro";
    GOBIN = "$HOME/go/bin";
    GOMODCACHE = "$HOME/go/pkg/mod";
    GOPATH = "$HOME/go";
    COPY_COMMAND = "xc";
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    PATH = "$GOBIN:$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH";
  };

  home.sessionPath = [
    "$GOBIN"
    "$HOME/.local/bin"
    "$HOME/.npm-packages/bin"
  ];

  programs.bash.enable = true;
  nix.package = pkgs.nix;
  nix.settings.experimental-features = ["flakes" "nix-command" "repl-flake" "ca-derivations" "auto-allocate-uids"];
  nix.settings.keep-derivations = true;
  nix.settings.keep-outputs = true;
  nix.settings.auto-optimise-store = true;

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
    enable = true;
    enableAutosuggestions = true;
    enableVteIntegration = true;

    initExtraFirst = ''
      # p10k instant prompt
      local P10K_INSTANT_PROMPT="${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
      [[ ! -r "$P10K_INSTANT_PROMPT" ]] || source "$P10K_INSTANT_PROMPT"

      export GPG_TTY=$TTY

      zstyle :omz:plugins:ssh-agent agent-forwarding on
      zstyle :omz:plugins:ssh-agent helper ksshaskpass
      zstyle :omz:plugins:ssh-agent lazy yes
      zstyle :omz:plugins:ssh-agent lifetime 300m
    '';

    defaultKeymap = "emacs";

    plugins = [
      {
        file = "powerlevel10k.zsh-theme";
        name = "powerlevel10k";
        src = "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";
      }
      {
        file = "p10k.zsh";
        name = "powerlevel10k-config";
        src = ../../dotfiles/.;
      }
      # {
      #   file = "zsh-z.plugin.zsh";
      #   name = "zsh-z";
      #   src = "${pkgs.zsh-z}/share/zsh-z";
      # }
      {
        file = "fast-syntax-highlighting.plugin.zsh";
        name = "zsh-fast-syntax-highlighting";
        src = "${pkgs.zsh-fast-syntax-highlighting}/share/zsh/site-functions/";
      }
      {
        file = "fzf-tab.plugin.zsh";
        name = "zsh-fzf-tab";
        src = "${pkgs.zsh-fzf-tab}/share/fzf-tab/";
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
          rev = "7cec4020c0f84f4bbc33ca3a613d1ab1f20b1795";
          sha256 = "sha256-LHFkAkf0QfOoQfsE8TZEK/zdDjfP8hnRHm+uByh0vZ4=";
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
          rev = "6e532a48e46ae56daec18255512dd8d0597f4aa6";
          sha256 = "sha256-nlumBGteG4RcQI0xLLFk6AZbz1TsBc2naTMlPdTCpEk=";
        };
      }
      (omzp "sudo")
      (omzl "functions" "functions.zsh")
      (omzp "web-search")
      (omzp "dirhistory")
      (omzp "golang")
      (omzl "git-lib" "git.zsh")
      (omzp "git")
      (omzp "ssh-agent")
      (omzp "colored-man-pages")
    ];

    completionInit = ''
      zstyle :compinstall filename '~/.zshrc'
      zstyle ':completion:*:default' menu select=1
      zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=* r:|=*'
      zstyle ':completion:*' list-colors ""
      zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#) ([0-9a-z-]#)*=01;34=0=01'

      zmodload -i zsh/complist
      autoload -U compinit && compinit
      autoload bashcompinit && bashcompinit
      command -v terraform > /dev/null && complete -o nospace -C ${pkgs.terraform}/bin/terraform terraform
      command -v vault > /dev/null && complete -o nospace -C vault vault

      unsetopt MENU_COMPLETE
      unsetopt FLOW_CONTROL
      setopt AUTO_MENU
      setopt COMPLETE_IN_WORD
      setopt ALWAYS_TO_END
      setopt NO_LIST_BEEP
      setopt LIST_PACKED
      setopt HIST_IGNORE_ALL_DUPS
    '';

    initExtra = ''
      ### Functions ###

      xc() {
          xclip -selection clipboard
      }

      hm() {
        home-manager --flake ~/nix-config $@
      }

      hms() {
        home-manager switch --flake ~/nix-config $@ && exec $SHELL
      }

      hmu() {
        nix flake update ~/nix-config $@
      }

      nrs() {
        sudo nixos-rebuild switch --flake ~/nix-config/ $@ && exec $SHELL
      }

      nd() {
          nix develop $@ --command zsh
      }

      ns() {
          nix shell $@ --command zsh
      }

      fzf-process-widget() {
          local pid=( $(ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' ') )
          LBUFFER="$LBUFFER$pid"
      }
      zle -N fzf-process-widget

      fzf-port-widget() {
          sudo true
          local port=( $(sudo lsof -i -P -n | fzf | sed 's/^ *//' | tr -s " " | cut -f2 -d' ') )
          LBUFFER="$LBUFFER$port"
      }
      zle -N fzf-port-widget

      WORDCHARS=""
      STATEMENTCHARS="@\,:\"'~=!#$%^&*(){}[]<>?+_-/;."

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
          zle backward-word
      }
      zle -N backward-statement

      forward-statement () {
          local WORDCHARS=$STATEMENTCHARS
          zle forward-word
      }
      zle -N forward-statement

      fif() {
          if [ ! "$#" -gt 0 ]; then echo "Need a string to search for!"; return 1; fi
          local file
          file="$(rga --max-count=1 --ignore-case --files-with-matches --no-messages "$*" | fzf-tmux +m --preview="rga --ignore-case --pretty --context 10 '"$*"' {}")" && echo "opening $file" && open "$file" || return 1;
      }

      rga-fzf() {
          RG_PREFIX="rga --files-with-matches"
          local file
          file="$(
              FZF_DEFAULT_COMMAND="$RG_PREFIX '$1'" \
                  fzf --sort --preview="[[ ! -z {} ]] && rga --pretty --context 5 {q} {}" \
                      --phony -q "$1" \
                      --bind "change:reload:$RG_PREFIX {q}" \
                      --preview-window="70%:wrap"
          )" &&
          echo "opening $file" &&
          xdg-open "$file"
      }

      # sfs creates a temporary directory and mounts a remote filesystem to it. Usage: sfs core@ares.unchain.io
      sfs() {
          mkdir /tmp/$1
          sshfs $1:/ /tmp/$1

          # Replace dolphin with the file explorer you use
          nohup dolphin /tmp/$1 &>/dev/null &
      }

      # sin adds a new entry to your ssh config file. Usage: sin ares core ares.unchain.io
      sin() {
      cat << EOF >> ~/.ssh/config

      Host $1
          User $2
          HostName $3

      EOF
      }

      ### Key binds ###


      function mkdest() {
          local positional=()

          while (( $# )); do
              case $1 in
              --)                 shift; positional+=("$*"); break  ;;
              -*)                            ;;
              *)                  positional+=("$1")         ;;
              esac
              shift
          done
          local target="$positional[-1]"
          local dir

          if [[ "$target" =~ '/$' ]]; then
              dir="$target"
          else
              dir="$(dirname "$target")"
          fi

          test -d "$dir" || mkdir -vp "$dir"
      }

      function cp() {
          mkdest "$@"
          command cp "$@"
      }


      function cpp() {
          command cp "$@"
      }

      function mv() {
          mkdest "$@"
          command mv "$@"
      }

      function mvv() {
          command mv "$@"
      }

      function ww() {
          local paths=()
          local lines=()
          while IFS= read -r line; do
              if [[ $line =~ ^/ ]]; then
                  paths+=("$line")
              else
                  lines+=("$line")
              fi
          done < <(which "$@");

          if [[ ! ''${#paths[@]} -eq 0 ]]; then
              realpath $paths | xargs exa -alh --group-directories-first --color always --icons
          fi

          for i in $lines; do
              echo $i
          done
      }


      # Ctrl+LeftArrow
      bindkey '^[[1;5D' backward-word

      # Ctrl+RightArrow
      bindkey '^[[1;5C' forward-word

      # Alt+LeftArrow
      bindkey '^[[1;3D' backward-statement

      # Alt+RightArrow
      bindkey '^[[1;3C' forward-statement

      # Ctrl+Backspace
      bindkey '^H' backward-delete-word

      # Alt+Backspace
      bindkey '^[^?' backward-delete-statement

      # Ctrl+Delete
      bindkey '^[[3;5~' kill-word

      # Alt+Delete
      bindkey '^[[3;3~' kill-statement

      # Ctrl+G
      bindkey '^G' fzf-file-widget
      bindkey '^P' fzf-process-widget
      bindkey '^O' fzf-port-widget

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
      bindkey $ACTION_SELECT_FORWARD_STATEMENT widget::action-select-forward-statement

      function widget::action-select-backward-statement() {
          widget::util-select backward-statement $@
      }
      zle -N widget::action-select-backward-statement
      bindkey $ACTION_SELECT_BACKWARD_STATEMENT widget::action-select-backward-statement

      function widget::action-unselect-forward-statement() {
          widget::util-unselect forward-statement $@
      }
      zle -N widget::action-unselect-forward-statement
      bindkey $ACTION_UNSELECT_FORWARD_STATEMENT widget::action-unselect-forward-statement

      function widget::action-unselect-backward-statement() {
          widget::util-unselect backward-statement $@
      }
      zle -N widget::action-unselect-backward-statement
      bindkey $ACTION_UNSELECT_BACKWARD_STATEMENT widget::action-unselect-backward-statement

      ### Aliases ###

      ### Theme ###

      typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|make'

      POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(os_icon dir vcs newline prompt_char)
      # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status root_indicator command_execution_time background_jobs history direnv goenv nodeenv fvm kubecontext terraform context nordvpn nnn midnight_commander nix_shell time newline go_version)
      POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time direnv kubecontext context nix_shell time)


      export ZSH_AUTOSUGGEST_USE_ASYNC="on";
      export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=12";
      export EDITOR="micro";
      export GOBIN="$HOME/go/bin";
      export GOMODCACHE="$HOME/go/pkg/mod";
      export GOPATH="$HOME/go";
      export COPY_COMMAND="xc";
      export NODE_PATH="$HOME/.npm-packages/lib/node_modules";
      export PATH="$GOBIN:$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH";
      export ZSH_WEB_SEARCH_ENGINES=(nixpkgs "https://search.nixos.org/packages?channel=unstable&from=0&size=50&sort=relevance&type=packages&query=")

      [ -f  ~/nix-config/dotfiles/.zshrc ] && source ~/nix-config/dotfiles/.zshrc
    '';

    history = {
      size = 10000;
      path = "$HOME/.zsh_history";
      ignoreDups = true;
    };
  };

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "23.05";
}
