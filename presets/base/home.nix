{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  imports = [../minimal/home.nix ../../modules/home/news.nix];
  home = {
    file = {
      ".local/bin/op-run" = {
        source = ./op-run;
        executable = true;
      };
    };
    sessionVariables = {EDITOR = "code-insiders";};

    shellAliases = {
      code = "code-insiders ";
      k = "kubectl";
      kx = "kubectx";
      kn = "kubens ";
    };
    packages = [
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
      pkgs.bun2
      pkgs.distrobox
      # pkgs.terraform
      # pkgs.nebula

      # NETWORKING ##
      pkgs.strongswan
      pkgs.nmap-unfree
      # pkgs.sofia_sip
      pkgs.inetutils
      pkgs.host.dnsutils

      pkgs.docker-compose
      pkgs.containerd
      pkgs.runc

      pkgs.patchelf
      pkgs.steam-run
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
      pkgs.screen
      pkgs.cacert
      # pkgs.cmctl
      # pkgs.udisks2
      pkgs.pam_mount
      # pkgs.killall
      # pkgs.nixos-install-tools
      # pkgs.kmod
      pkgs.bashInteractiveFHS
      pkgs.asciinema
      pkgs.asciinema-agg
      pkgs.socat

      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ];
  };

  programs = {
    ssh = {
      forwardAgent = lib.mkDefault true;
      enable = lib.mkDefault true;
    };

    texlive = {enable = true;};
    zsh.extra.enable = true;
    git = {
      signing = {
        signByDefault = true;
        gpgPath = "${pkgs.openssh}/bin/ssh-keygen";
        key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
      };

      extraConfig = {
        # url = {
        #   "git@github.com:" = {insteadOf = "https://github.com/";};
        #   "ssh://git@bitbucket.org/" = {insteadOf = "https://bitbucket.org/";};
        # };
        gpg = {
          format = "ssh";
          ssh.program =
            lib.mkDefault "${pkgs._1password-gui}/share/1password/op-ssh-sign";
        };
      };
    };
  };

  services = {
    ssh-agent.enable = false;
    gpg-agent.enable = false;
  };

  nix.settings = {
    extra-platforms = [
      "armv7l-linux"
      "armv7l-hf-multiplatform"
      "armv7l-multiplatform"
      "aarch64-linux"
      "i686-linux"
    ];

    cores = 4;
  };
  systemd.user = {
    timers.custom-home-manager-auto-upgrade = {
      Unit.Description = "Home Manager upgrade timer";

      Install.WantedBy = ["timers.target"];

      Timer = {
        OnCalendar = "*-*-* 08:56:00";
        Unit = "custom-home-manager-auto-upgrade.service";
        Persistent = true;
      };
    };

    services.custom-home-manager-auto-upgrade = {
      Unit.Description = "Home Manager upgrade";

      Service.ExecStart =
        toString
        (pkgs.writeShellScript "home-manager-auto-upgrade" ''
          export PATH=$PATH:${pkgs.openssh}/bin:${pkgs.git}/bin:${pkgs.nixUnstable}/bin
          echo PATH: $PATH
          if [[ ! -d ${me.flake-path} ]]; then
            echo "${me.flake-path} does not exist, skipping update"
            exit 0
          fi

          cd ${me.flake-path}
          branch_name="$(${pkgs.git}/bin/git rev-parse --abbrev-ref HEAD)"
          if [ "$branch_name" != "master" ]; then
            echo "Current branch $branch_name is not master, skipping update"
            exit 0
          fi
          if [[ $(${pkgs.git}/bin/git diff --stat) != "" ]]; then
            echo 'Dirty working tree, skipping update'
            exit 0
          fi

          echo "Fetching latest changes"
          ${pkgs.git}/bin/git fetch

          if [[ ! $(${pkgs.git}/bin/git log HEAD..origin/master --oneline) ]]; then
            echo "Up-to-date"
            exit 0
          fi

          if [[ $(${pkgs.git}/bin/git log origin/master..HEAD --oneline) ]]; then
            echo "Unpushed commits, skipping update"
            exit 0
          fi

          echo "Pulling latest changes"
          ${pkgs.git}/bin/git pull ${me.flake-repo}

          echo "Upgrading home environment"
          ${pkgs.home-manager}/bin/home-manager switch --flake ${me.flake-path}
        '');
    };
  };
}
