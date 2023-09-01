{ config, pkgs, values, inputs, ... }:
let

in
{
  home.packages = [
    ## THESIS ##

    pkgs.haskellPackages.pandoc
    pkgs.haskellPackages.pandoc-crossref
    pkgs.pandoc
    pkgs.python3
    pkgs.python310Packages.pygments

    ## EDITORS ##
    pkgs.inkscape
    pkgs.librsvg
    pkgs.drawio
    pkgs.obsidian
    pkgs.evince

    ## MPYC ##
    pkgs.stuntman
    pkgs.libnatpmp
    pkgs.miniupnpc
    pkgs.wireguard-tools
    pkgs.wireguard-go
    pkgs.coturn
    pkgs.terraform
    pkgs.nebula
    pkgs.python3Packages.autopep8

    ## NETWORKING ##
    pkgs.tailscale
    pkgs.strongswan
    pkgs.nmap-unfree
    pkgs.sofia_sip
    pkgs.inetutils
    pkgs.host.dnsutils

    ## DEV ##
    pkgs.cachix
    pkgs.devenv
    # pkgs.devbox
    # pkgs.asdf-vm

    pkgs.docker
    pkgs.docker-compose
    pkgs.containerd
    pkgs.runc

    pkgs.patchelf
    pkgs.steam-run
    pkgs.nix-ld
    pkgs.nix-alien

    ## CLOUD ##
    pkgs.kubernetes-helm
    pkgs.awscli2
    pkgs.doctl
    pkgs.vault

    ## LANGUAGES ##
    pkgs.gcc
    pkgs.ent-go
    pkgs.elixir
    pkgs.R
    pkgs.rstudio

    ## UTILS ##
    pkgs.git-filter-repo
    pkgs.inotify-tools
    pkgs.qrencode
    pkgs.screen
    pkgs.cacert
    pkgs.zotero
    pkgs.cmctl
    pkgs.udisks2
    pkgs.pam_mount
    pkgs.rc2nix
    pkgs.killall
    pkgs.nixos-install-tools
    pkgs.kmod


    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay

  ] ++ [ ];


  programs.texlive = {
    enable = true;
  };

  nix.settings.extra-platforms = [ "armv7l-linux" "armv7l-hf-multiplatform" "armv7l-multiplatform" "aarch64-linux" "i686-linux" ];
  nix.settings.cores = 4;

  nix.settings.substituters = [ "https://cache.nixos.org/" "https://devenv.cachix.org/" "https://nixpkgs-python.cachix.org" ];
  nix.settings.trusted-public-keys = [ "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY=" "devenv.cachix.org-1:w1cLUi8dv3hnoSPGAuibQv+f9TZLr6cv/Hm9XgU50cw=" "nixpkgs-python.cachix.org-1:hxjI7pFxTyuTHn2NkvWCrAUcNZLNS3ZAvfYNuYifcEU=" ];
  # nix.settings.extra-trusted-substituters = [ "https://cache.armv7l.xyz" ];
  # nix.settings.extra-trusted-public-keys = [ "cache.armv7l.xyz-1:kBY/eGnBAYiqYfg0fy0inWhshUo+pGFM3Pj7kIkmlBk=" ];

  programs.zsh = {
    enable = true;

    completionInit = ''
    '';

    initExtraFirst = ''
      eval "$(zellij setup --generate-auto-start zsh)"
    '';

    initExtra = ''
      command -v wg > /dev/null && . ~/.nix-profile/share/bash-completion/completions/wg
      command -v wg-quick > /dev/null && . ~/.nix-profile/share/bash-completion/completions/wg-quick
    '';
  };

  # programs.zellij.enableZshIntegration = true;

  programs.git = {
    userName = "${values.gitUsername}";
    userEmail = "${values.email}";

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
  home.stateVersion = "22.11";
}
