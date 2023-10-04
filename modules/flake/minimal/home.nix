{ config, pkgs, lib, pkgs-stable, inputs, ... }@args: {
  imports = [ ../bare/home.nix ];
  programs.home-manager.enable = true;

  home.packages = [
    pkgs.nix
    pkgs.micro
    pkgs.htop
    pkgs.nixfmt
    pkgs.curl
    pkgs.git
    # pkgs-stable.ripgrep-all
    # pkgs.ripgrep-all
    pkgs.websocat
    # pkgs.file
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
    pkgs.fira-code
    pkgs.neofetch
    pkgs.sops
    pkgs.age
    pkgs.xxh
    pkgs.nixos-option
    pkgs.nix-doc
    pkgs.xdg-utils

    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay
  ] ++ [ ];
  targets.genericLinux.enable = true;
  xdg.enable = true;

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
      unbind = [
        "Alt Left"
        "Alt Right"
        "Ctrl 1"
        "Ctrl 3"
        "Ctrl 5"
        "Ctrl 2"
        "Ctrl h"
        "Alt ["
      ];
      normal = {
        "bind \"Ctrl 1\"" = { MoveFocusOrTab = "Left"; };
        "bind \"Ctrl 3\"" = { MoveFocusOrTab = "Right"; };
        "bind \"Ctrl 5\"" = { MoveFocus = "Down"; };
        "bind \"Ctrl 2\"" = { MoveFocus = "Up"; };
        "bind \"Ctrl e\"" = { SwitchToMode = "Tab"; };
        "bind \"Alt t\"" = { NewTab = ""; };
        "bind \"Ctrl [\"" = { PreviousSwapLayout = ""; };
        "bind \"Ctrl ]\"" = { NextSwapLayout = ""; };
      };
    };
  };

  programs.git = {
    enable = true;
    difftastic = {
      enable = true;
      background = "dark";
      color = "always";
      display = "side-by-side-show-both";
    };

    extraConfig = {
      core = { editor = lib.mkDefault "micro"; };
      credential = { helper = lib.mkDefault "cache --timeout=3600"; };

      pull = { ff = lib.mkDefault "only"; };
    };
  };

  programs.gitui.enable = true;
  programs.pls.enable = true;
  # programs.carapace.enable = true;
  programs.eza = { enable = true; };

  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  fonts.fontconfig.enable = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.shellAliases = {
    xargs = "xargs ";

    gct = "git commit -am 'tmp'";

    l = "eza";
    ls =
      "eza -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
    lsa = "ls -a ";
    tree = "eza --tree -alh --group-directories-first --color always --icons ";
    grep = "grep --color --ignore-case --line-number --context=3 ";
    df = "df -h ";

    zfg = "code ~/.zshrc";
    src = "source ~/.zshrc";

    port = "sudo lsof -i -P -n | fzf";
    pp =
      "ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

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
    TERM = "xterm-256color";
    ZSH_AUTOSUGGEST_USE_ASYNC = "on";
    ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE = "fg=12";
    EDITOR = lib.mkDefault "vi";
    GOBIN = "$HOME/go/bin";
    GOMODCACHE = "$HOME/go/pkg/mod";
    GOPATH = "$HOME/go";
    COPY_COMMAND = "xc";
    NODE_PATH = "$HOME/.npm-packages/lib/node_modules";
    # PATH = "$GOBIN:$HOME/.local/bin:$HOME/.npm-packages/bin:$PATH";
    HOME_MANAGER_CONFIG = "$HOME/nix-config";
    KEYTIMEOUT = "10";
  };

  home.sessionPath = [ "$GOBIN" ];

  programs.bash = {
    enable = true;

    initExtra = ''
      ### Functions ###

      xc() {
          xclip -selection clipboard
      }

      nhs() {
        home-manager switch --flake ~/nix-config $@ && exec bash
      }

      nrs() {
        sudo nixos-rebuild switch --flake ~/nix-config/ $@ && exec bash
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
          done < <(which "$@")

          if [[ ! ''${#paths[@]} -eq 0 ]]; then
              realpath $paths | xargs eza -alh --group-directories-first --color always --icons
          fi

          for i in $lines; do
              echo $i
          done
      }

      function has_flag() {
          local flag_pattern=$1
          shift

          local positional=()
          while (($#)); do
              opt=$1
              shift

              if [[ $opt =~ ^$flag_pattern ]]; then
                  return 1
              fi
          done
      }

      function nd() {
          has_flag "-c|--command" "$@"
          local hf=$?
          if [ $hf = 1 ]; then
              nix develop "$@"
          else
              nix develop "$@" --command bash
          fi
      }

      nar() {
        path=$1
        cache=$2

        if [ -z "$cache" ]; then
          cache="https://cache.nixos.org/"
        fi

        path=$(echo "/nix/store/cw63r63gnm62rny5xx0apri8qywzx98j-file-5.45" | sed -n 's/\/nix\/store\/\([a-zA-Z0-9]*\)-.*/\1/p')
        url="https://$cache$path.narinfo"
        curl -L $url
      }

      [ -f  ~/nix-config/dotfiles/.bashrc ] && . ~/nix-config/dotfiles/.bashrc
    '';
  };

  services.ssh-agent.enable = true;

  programs.zsh =
    let
      omzp = name: {
        inherit name;
        src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${name}";
      };
      omzl = name: file: {
        inherit name file;
        src = "${pkgs.oh-my-zsh}/share/oh-my-zsh/lib/";
      };
    in
    {
      enable = true;
      enableAutosuggestions = true;
      enableVteIntegration = true;

      initExtraFirst = ''
        command -v direnv > /dev/null && eval "$(${config.programs.direnv.package}/bin/direnv export zsh)"

        # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
        # Initialization code that may require console input (password prompts, [y/n]
        # confirmations, etc.) must go above this block; everything else may go below.
        if [[ -r "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh" ]]; then
          source "${config.xdg.cacheHome}/p10k-instant-prompt-''${(%):-%n}.zsh"
        fi

        export GPG_TTY=$TTY

        zstyle :omz:plugins:ssh-agent agent-forwarding yes
        zstyle :omz:plugins:ssh-agent helper ksshaskpass
        zstyle :omz:plugins:ssh-agent lazy yes
        zstyle :omz:plugins:ssh-agent quiet yes
        zstyle :omz:plugins:ssh-agent lifetime 5h
        zstyle :omz:plugins:ssh-agent identities id_rsa

        # Stolen from ArchWiki

        # create a zkbd compatible hash;
        # to add other keys to this hash, see: man 5 terminfo
        typeset -A key

        key[Home]=''${terminfo[khome]}

        key[End]=''${terminfo[kend]}
        key[Insert]=''${terminfo[kich1]}
        key[Delete]=''${terminfo[kdch1]}
        key[Up]=''${terminfo[kcuu1]}
        key[Down]=''${terminfo[kcud1]}
        key[Left]=''${terminfo[kcub1]}
        key[Right]=''${terminfo[kcuf1]}
        key[PageUp]=''${terminfo[kpp]}
        key[PageDown]=''${terminfo[knp]}

        # setup key accordingly
        [[ -n "''${key[Home]}"     ]]  && bindkey  "''${key[Home]}"     beginning-of-line
        [[ -n "''${key[End]}"      ]]  && bindkey  "''${key[End]}"      end-of-line
        [[ -n "''${key[Insert]}"   ]]  && bindkey  "''${key[Insert]}"   overwrite-mode
        [[ -n "''${key[Delete]}"   ]]  && bindkey  "''${key[Delete]}"   delete-char
        [[ -n "''${key[Up]}"       ]]  && bindkey  "''${key[Up]}"       up-line-or-history
        [[ -n "''${key[Down]}"     ]]  && bindkey  "''${key[Down]}"     down-line-or-history
        [[ -n "''${key[Left]}"     ]]  && bindkey  "''${key[Left]}"     backward-char
        [[ -n "''${key[Right]}"    ]]  && bindkey  "''${key[Right]}"    forward-char
        [[ -n "''${key[PageUp]}"   ]]  && bindkey  "''${key[PageUp]}"   beginning-of-buffer-or-history
        [[ -n "''${key[PageDown]}" ]]  && bindkey  "''${key[PageDown]}" end-of-buffer-or-history
        bindkey '^[[H' beginning-of-line
        bindkey '^[[F' end-of-line
        bindkey '^[Z' redo
        # Finally, make sure the terminal is in application mode, when zle is
        # active. Only then are the values from $terminfo valid.
        if (( ''${+terminfo[smkx]} )) && (( ''${+terminfo[rmkx]} )); then
            function zle-line-init () {
                printf '%s' "''${terminfo[smkx]}"
            }
            function zle-line-finish () {
                printf '%s' "''${terminfo[rmkx]}"
            }
            zle -N zle-line-init
            zle -N zle-line-finish
          
        fi
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
            rev = "b0aea4e348ece04feb9e4009b0c4e0f114c2875f";
            sha256 = "sha256-NBa/rnVpi3UdlkWX5uoFUN4sBXdaMMD+rvJ5nsA8yP8=";
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

        nhs() {
          home-manager switch --flake ~/nix-config $@ && exec zsh
        }

        nrs() {
          sudo nixos-rebuild switch --flake ~/nix-config $@ && exec zsh
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
            done < <(which "$@")

            if [[ ! ''${#paths[@]} -eq 0 ]]; then
                realpath $paths | xargs eza -alh --group-directories-first --color always --icons
            fi

            for i in $lines; do
                echo $i
            done
        }

        function has_flag() {
            local flag_pattern=$1
            shift

            local positional=()
            while (($#)); do
                opt=$1
                shift

                if [[ $opt =~ ^$flag_pattern ]]; then
                    return 1
                fi
            done
        }

        function nd() {
            has_flag "-c|--command" "$@"
            local hf=$?
            if [ $hf = 1 ]; then
                nix develop "$@"
            else
                nix develop "$@" --command zsh
            fi
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
        STATEMENTCHARS="@:\"'~=#$%^&*+_-;."

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
                realpath $paths | xargs eza -alh --group-directories-first --color always --icons
            fi

            for i in $lines; do
                echo $i
            done
        }

        # Alt+Backspace
        bindkey '^[^?' backward-delete-statement

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

        ### Theme ###

        typeset -g POWERLEVEL9K_KUBECONTEXT_SHOW_ON_COMMAND='kubectl|helm|kubens|kubectx|oc|istioctl|kogito|k9s|helmfile|make'
        function prompt_shell_level() {
            local lvl=$SHLVL

            if [[ $lvl -gt 1 ]]; then
                p10k segment -f blue -i '⭐' -t "$SHLVL"
            fi
        }

        PROMPT_EOL_MARK=""
        POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(shell_level os_icon dir vcs newline prompt_char)
        POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(newline status root_indicator command_execution_time background_jobs history direnv goenv nodeenv fvm kubecontext terraform context nordvpn nnn midnight_commander nix_shell time newline go_version)
        # POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(status command_execution_time direnv kubecontext context nix_shell time)

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