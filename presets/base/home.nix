{
  config,
  pkgs,
  lib,
  personal-info,
  inputs,
  outputs,
  ...
}: {
  imports = [
    ../minimal/home.nix
  ];

  # https://github.com/nix-community/home-manager/issues/2033#issuecomment-1848326144
  news.display = "silent";
  news.json = lib.mkForce {};
  news.entries = lib.mkForce [];
  # targets.genericLinux.enable = lib.mkForce false;

  # disabledModules = [
  #   "misc/news.nix" # https://github.com/nix-community/home-manager/issues/2033
  # ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = {allowUnfree = true;};
  };

  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      Host *
            IdentityAgent ~/.1password/agent.sock
    '';
  };
  home.packages =
    [
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

      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];

  programs.texlive = {enable = true;};

  nix.settings.extra-platforms = [
    "armv7l-linux"
    "armv7l-hf-multiplatform"
    "armv7l-multiplatform"
    "aarch64-linux"
    "i686-linux"
  ];
  services.home-manager.autoUpgrade.enable = true;
  services.home-manager.autoUpgrade.frequency = "*-*-* 08:56:00";

  home.sessionVariables = {
    EDITOR = "code-insiders";
  };

  nix.settings.cores = 4;
  home.shellAliases = {
    code = "code-insiders ";
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
  };
  programs.zsh.extra.enable = true;

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
        ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";
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
