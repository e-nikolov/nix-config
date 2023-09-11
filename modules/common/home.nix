{
  config,
  pkgs,
  values,
  inputs,
  ...
}: {
  imports = [
    ../minimal/home.nix
  ];

  home.packages =
    [
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
    ]
    ++ [];

  programs.texlive = {
    enable = true;
  };

  nix.settings.extra-platforms = ["armv7l-linux" "armv7l-hf-multiplatform" "armv7l-multiplatform" "aarch64-linux" "i686-linux"];
  nix.settings.cores = 6;
  home.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
  };
  programs.zsh = {
    enable = true;

    completionInit = ''
    '';

    initExtraFirst = ''
      # eval "$(zellij setup --generate-auto-start zsh)"
    '';

    initExtra = ''
      command -v wg > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg
      command -v wg-quick > /dev/null && . ${config.home.profileDirectory}/share/bash-completion/completions/wg-quick
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
      sudo = ''sudo -E env "PATH=$PATH" '';

      xargs = "xargs ";

      gct = "git commit -am 'tmp'";

      l = "eza";
      ls = "eza -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree = "eza --tree -alh --group-directories-first --color always --icons ";
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

  programs.git = {
    signing = {
      signByDefault = true;
      gpgPath = "${pkgs.openssh}/bin/ssh-keygen";
      key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };
    extraConfig = {
      url = {
        "git@github.com:" = {insteadOf = "https://github.com/";};
        "ssh://git@bitbucket.org/" = {insteadOf = "https://bitbucket.org/";};
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
