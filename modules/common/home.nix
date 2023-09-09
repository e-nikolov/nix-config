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

  programs.git = {
    signing = {
      signByDefault = true;
      gpgPath = "${pkgs.openssh}/bin/ssh-keygen";
      key = "${config.home.homeDirectory}/.ssh/id_rsa.pub";
    };
    extraConfig = {
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
