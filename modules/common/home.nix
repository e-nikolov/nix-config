{ config, pkgs, lib, values, inputs, outputs, ... }:
let
  inherit (inputs.nix-colors) colorSchemes;
  inherit (inputs.nix-colors.lib-contrib { inherit pkgs; })
    colorschemeFromPicture nixWallpaperFromScheme;
in {
  #   disableHomeManagerNews = {
  #   # disabledModules = [ "misc/news.nix" ];
  #   config = {
  #   };
  # };

  # disabledModules = [
  #   "misc/news.nix" # https://github.com/nix-community/home-manager/issues/2033
  # ];

  imports = [
    ../minimal/home.nix
    ../home-manager/nvim
    ../home-manager/nushell

    inputs.nix-colors.homeManagerModule
  ];

  nixpkgs = {
    overlays = builtins.attrValues outputs.overlays;
    config = { allowUnfree = true; };
  };
  colorscheme = lib.mkDefault colorSchemes.dracula;

  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      Host *
            IdentityAgent ~/.1password/agent.sock
    '';
  };
  home.packages = [
    pkgs.bashInteractiveFHS
    pkgs.nil
    pkgs.nixd
    pkgs.asciinema
    pkgs.asciinema-agg
    # THESIS ##

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
    pkgs.devenv
    pkgs.bun2
    # pkgs.terraform
    # pkgs.nebula
    # pkgs.python3Packages.autopep8

    # NETWORKING ##
    pkgs.strongswan
    pkgs.nmap-unfree
    # pkgs.sofia_sip
    pkgs.inetutils
    pkgs.host.dnsutils

    # # DEV ##
    # pkgs.devbox
    # pkgs.asdf-vm

    # pkgs.docker
    pkgs.docker-compose
    pkgs.containerd
    pkgs.runc

    pkgs.patchelf
    # # ? 
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
    pkgs.bat

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
  services.home-manager.autoUpgrade.enable = true;
  services.home-manager.autoUpgrade.frequency = "*-*-* 08:56:00";

  nix.settings.cores = 4;
  home.shellAliases = {
    k = "kubectl";
    kx = "kubectx";
    kn = "kubens";
  };
  programs.zsh.extra.enable = true;

  programs.bat.enable = true;
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
