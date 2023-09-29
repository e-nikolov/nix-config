{ config, pkgs, lib, values, inputs, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    colorschemeFromPicture nixWallpaperFromScheme;
in
{
  imports = [
    ../minimal/home.nix
    ../home-manager/nvim
    inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };

  colorscheme = lib.mkDefault colorSchemes.dracula;

  home.packages = [
    # THESIS ##

    # pkgs.haskellPackages.pandoc
    # pkgs.haskellPackages.pandoc-crossref
    # pkgs.pandoc
    # pkgs.python310Packages.pygments

    # EDITORS ##
    # pkgs.inkscape
    # pkgs.librsvg
    # pkgs.drawio
    # pkgs.obsidian
    # pkgs.evince

    # MPYC ##
    # pkgs.stuntman
    # pkgs.libnatpmp
    # pkgs.miniupnpc
    pkgs.wireguard-tools
    pkgs.wireguard-go
    pkgs.coturn
    # pkgs.terraform
    # pkgs.nebula
    # pkgs.python3Packages.autopep8

    # NETWORKING ##
    pkgs.tailscale
    pkgs.strongswan
    pkgs.nmap-unfree
    # pkgs.sofia_sip
    pkgs.inetutils
    pkgs.host.dnsutils

    # # DEV ##
    # pkgs.devbox
    # pkgs.asdf-vm

    pkgs.docker
    pkgs.docker-compose
    pkgs.containerd
    pkgs.runc

    pkgs.patchelf
    # # ? pkgs.steam-run
    pkgs.nix-ld
    # # ? pkgs.nix-alien

    # # CLOUD ##
    # pkgs.kubernetes-helm
    # pkgs.awscli2
    # pkgs.doctl
    # pkgs.vault
    # pkgs.kubectl
    # pkgs.kubectx

    # LANGUAGES ##
    pkgs.go
    # pkgs.gcc
    # pkgs.ent-go
    # pkgs.rustc
    # pkgs.python3
    # pkgs.nodejs
    # pkgs.elixir
    # pkgs.R
    # pkgs.rstudio

    ## UTILS ##
    pkgs.git-filter-repo
    pkgs.inotify-tools
    # pkgs.qrencode
    pkgs.screen
    pkgs.cacert
    # pkgs.cmctl
    # pkgs.udisks2
    pkgs.pam_mount
    # pkgs.killall
    # pkgs.nixos-install-tools
    # pkgs.kmod
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix
    pkgs.manix
    pkgs.nb

    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay
  ] ++ [ ];

  programs.texlive = { enable = true; };

  nix.settings.extra-platforms = [
    "armv7l-linux"
    "armv7l-hf-multiplatform"
    "armv7l-multiplatform"
    "aarch64-linux"
    "i686-linux"
  ];
  nix.settings.cores = 6;
  home.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
  };
  programs.zsh = {
    enable = true;

    completionInit = "";

    initExtraFirst = ''
      # eval "$(zellij setup --generate-auto-start zsh)"
    '';

    initExtra = ''
      command -v wg > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg
      command -v wg-quick > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg-quick

      export PATH=$PATH:"$HOME/.cargo/bin"

      _nar() {
          store_path=$1
          cache=$2
          quiet=$3

          store_path=$(echo $store_path | sed -n 's/\/nix\/store\/\([a-zA-Z0-9]*\)-.*/\1/p')
          url="$cache$store_path.narinfo"

          out=$(curl -s $url)
          if [ "$quiet" ]; then
              if [ "$out" = 404 ]; then
                  out="(-)"
              else
                  out="(+)"
              fi
              echo $url $out
          else
              echo $url
              echo $out
          fi

      }

      alias nar='nix path-info --eval-store auto --store https://cache.nixos.org '
      alias narp='nix build --dry-run 2>&1 '

      f() {
          find $@ -maxdepth 1 -mindepth 1
      }

      _nsf() {
          find /nix/store -maxdepth 1 -mindepth 1 | fzf -m ''${@:+"-q $@"}
      }

      if [[ -d $XDG_STATE_PATH ]]; then 
        STATE_PATH=$XDG_STATE_HOME/scripts/nsf
        if [ ! -d $STATE_PATH ]; then
            mkdir -p $STATE_PATH
        fi
      fi

      NSF_PIPE_CONSUMED_STATE_PATH=$STATE_PATH/nsf_pipe_consumed
      NSF_PATHS_STATE_PATH=$STATE_PATH/nsf_paths

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

      update_paths() {
          _NSF_PATHS=($(find /nix/store -maxdepth 1 -mindepth 1 | fzf -m ''${@:+"-q $@"}))
          if [[ ! -z $_NSF_PATHS ]]; then
              echo "$_NSF_PATHS" >$NSF_PATHS_STATE_PATH
              NSF_PATHS=$_NSF_PATHS
              touch $NSF_PIPE_CONSUMED_STATE_PATH
          fi
      }

      nsf() {
          has_flag "-s" "$@"
          local hf=$?
          if [ -f "$NSF_PIPE_CONSUMED_STATE_PATH" ]; then
              NSF_PIPE_CONSUMED=false
          else
              NSF_PIPE_CONSUMED=true
          fi
          if [ -f "$NSF_PATHS_STATE_PATH" ]; then
              NSF_PATHS=$(cat $NSF_PATHS_STATE_PATH)
          fi

          out_pipe=false
          if [[ ! -t 1 ]]; then
              out_pipe=true
          fi

          if [[ -z $NSF_PATHS || (($out_pipe == false || $NSF_PIPE_CONSUMED == true) && $hf == 0) ]]; then
              # * no out pipe or no past state
              update_paths
          fi

          if [[ $out_pipe == true && $hf == 0 ]]; then
              # * NF_PATHS set && flag -s or out pipe && pipe not consumed
              rm -f $NSF_PIPE_CONSUMED_STATE_PATH
              NSF_PIPE_CONSUMED=true
          fi

          echo $NSF_PATHS
      }

      nsfw() {
          # context "nsfw"
          has_flag "-s" "$@"
          local hf=$?

          if [ -f "$NSF_PATHS_STATE_PATH" ]; then
              NSF_PATHS=$(cat $NSF_PATHS_STATE_PATH)
          fi

          if [[ -z $NSF_PATHS ]]; then
              update_paths
          fi
          if [[ ! -t 1 && $hf == 0 ]]; then
              # * NF_PATHS set && flag -s or out pipe && pipe not consumed
              export NSF_PIPE_CONSUMED=true
          fi

          echo $NSF_PATHS
      }

      context() {
          name="$1 - context"
          if [ -t 0 ]; then
              if [ -t 1 ]; then
                  echo "$name: no pipes" >&2
              else
                  echo "$name: pipe out only" >&2
              fi
          else
              if [ -t 1 ]; then
                  echo "$name: pipe in only" >&2
              else
                  echo "$name: pipe in and out" >&2
              fi
          fi
      }

      nar2() {
          # context "nar2"

          local store_paths=()
          while [ $# -gt 0 ]; do
              opt="$1"
              shift

              case $opt in
              -q | --quiet)
                  quiet=1
                  ;;
              -c | --cache)
                  cache="$opt"
                  shift
                  ;;
              *)
                  store_paths+=("$opt")
                  ;;
              esac
          done

          if [ ! -t 0 ]; then
              while read line; do
                  store_paths+=($(echo $line | tr " " "\n"))
              done
          fi

          if [ ! "$cache" ]; then
              cache="https://cache.nixos.org/"
          fi

          for store_path in "''${store_paths[@]}"; do
              _nar $store_path $cache $quiet
          done
      }

      # __nsf () {
      #         local cmd="''${FZF_CTRL_T_COMMAND:-"command find -L . -mindepth 1 \\( -path '*/\\.*' -o -fstype 'sysfs' -o -fstype 'devfs' -o -fstype 'devtmpfs' -o -fstype 'proc' \\) -prune     -o -type f -print     -o -type d -print     -o -type l -print 2> /dev/null | cut -b3-"}"
      #         setopt localoptions pipefail no_aliases 2> /dev/null
      #         local item
      #         eval "$cmd" | FZF_DEFAULT_OPTS="--height ''${FZF_TMUX_HEIGHT:-40%} --reverse --bind=ctrl-z:ignore ''${FZF_DEFAULT_OPTS-} ''${FZF_CTRL_T_OPTS-}" $(__fzfcmd) -m "$@" | while read item
      #         do
      #                 echo -n "''${(q)item} "
      #         done
      #         local ret=$?
      #         echo
      #         return $ret
      # }

      # fzf-port-widget() {
      #     local port=( $(sudo lsof -i -P -n | fzf | sed 's/^ *//' | tr -s " " | cut -f2 -d' ') )
      #     LBUFFER="$LBUFFER$port"
      # }
      # zle -N fzf-port-widget

      # nsfw() {
      #     local paths=( $(find /nix/store -maxdepth 1 -mindepth 1 | fzf -m ''${@:+"-q $@"}) )
      #     echo $paths
      #     LBUFFER="$LBUFFER$paths"
      # }

      # zle -N nsfw
      # zle -N nsf-widget

    '';
  };

  programs.nushell = {
    enable = true;

    extraEnv = ''
      $env.config = {
        show_banner: false,

        keybindings: [
          {
            name: fuzzy_history_fzf
            modifier: control
            keycode: char_r
            mode: [emacs , vi_normal, vi_insert]
            event: {
              send: executehostcommand
              cmd: "commandline (
                history
                  | each { |it| $it.command }
                  | uniq
                  | reverse
                  | str join (char -i 0)
                  | fzf --read0 --tiebreak=chunk --layout=reverse  --multi --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline)
                  | decode utf-8
                  | str trim
              )"
            }
          },
          {
              name: fzf_history_menu_fzf_ui
              modifier: control
              keycode: char_e
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_history_menu_fzf_ui }
          }
          {
              name: fzf_history_menu_nu_ui
              modifier: control
              keycode: char_w
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_menu_nu_ui }
          }
          {
              name: fzf_dir_menu_nu_ui
              modifier: control
              keycode: char_q
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_dir_menu_nu_ui }
          }
        ]
      }
    '';
    extraConfig = ''


      ### Functions ###

      def xc [] {
          xclip -selection clipboard
      }

      extern-wrapped nhs [...args] {
        home-manager switch --flake ~/nix-config $args
        exec nu
      }

      extern-wrapped nrs [...args] {
        sudo nixos-rebuild switch --flake ~/nix-config/ $args
        exec nu
      }

      extern-wrapped nd [...args] {
        nix $args --command nu develop
      }
    '';

    shellAliases = {
      # ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
      nfu = "nix flake update ~/nix-config ";
      nh = "home-manager --flake ~/nix-config ";
      ns = "nix shell ";
      # nd = lib.mkDefault "nix develop ";
      gst = "git status ";
      gc = "git commit ";
      gcl = "git clone --recurse-submodules ";
      sudo = ''sudo -E env "PATH=$PATH" '';

      xargs = "xargs ";

      gct = "git commit -am 'tmp'";

      l = "eza";
      ls =
        "eza -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree =
        "eza --tree -alh --group-directories-first --color always --icons ";
      grep = "grep --color --ignore-case --line-number --context=3 ";
      df = "df -h ";

      zfg = "code ~/.zshrc";
      # src = "source ~/.zshrc";

      # port = "sudo lsof -i -P -n | fzf";
      # pp = "ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

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
  };

  programs.neovim.enable = true;
  programs.neovim.coc.enable = true;
  programs.neovim.viAlias = true;
  programs.neovim.vimdiffAlias = true;
  programs.neovim.withPython3 = true;
  programs.neovim.withNodeJs = true;

  programs.git = {
    signing = {
      signByDefault = true;
      gpgPath = "${pkgs.openssh}/bin/ssh-keygen";
      key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };
    extraConfig = {
      url = {
        "git@github.com:" = { insteadOf = "https://github.com/"; };
        "ssh://git@bitbucket.org/" = { insteadOf = "https://bitbucket.org/"; };
      };
      gpg = {
        format = "ssh";
        ssh.program = "${pkgs.openssh}/bin/ssh-keygen";
      };
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
