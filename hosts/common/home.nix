{ config, pkgs, values, inputs, ... }:
let
  markdown = pkgs.stdenv.mkDerivation {
    pname = "latex-markdown";
    version = "2.18.0-0-gd8ae860";
    tlType = "run";

    src = pkgs.fetchgit {
      url = "https://github.com/Witiko/markdown";

      leaveDotGit = true;
      fetchSubmodules = true;
      deepClone = true;
      rev = "refs/tags/2.18.0";
      sha256 = "sha256-wYmGEL1OrgSnVN4DA8PM13djAKtfRaK9nrbzV2/GMVU=";
    };

    nativeBuildInputs = [ pkgs.texlive.combined.scheme-small pkgs.bashInteractive pkgs.git ];

    buildPhase = ''
      runHook preBuild
      latex markdown.ins
      runHook postBuild
    '';

    installPhase = ''
      ls -alh
      ls -alh libraries/
      ls -alh libraries/lua-tinyyaml

      path="$out/tex/latex/markdown"
      mkdir -p "$path"
      cp *.sty "$path/"

      path="$out/tex/generic/markdown/"
      mkdir -p "$path"
      cp markdown.tex "$path/"

      path="$out/scripts/markdown/"
      mkdir -p "$path"
      cp markdown-cli.lua "$path/"

      path="$out/tex/luatex/markdown/"
      mkdir -p "$path"
      cp markdown.lua "$path/"
      cp libraries/lua-tinyyaml/tinyyaml.lua "$path/markdown-tinyyaml.lua"

      path="$out/tex/context/third/markdown/"
      mkdir -p "$path"
      cp t-markdown.tex "$path/"
    '';

    # # meta = with lib; {
    # # description = "A LaTeX2e class for overhead transparencies";
    # # license = licenses.unfreeRedistributable;
    # # maintainers = with maintainers; [ veprbl ];
    # # platforms = platforms.all;
    # # };
  };

  hp = pkgs.haskellPackages.override {
    overrides = self: super: {
      pandoc = super.pandoc_3_1;
      doctemplates = super.doctemplates_0_11;
      gridtables = super.gridtables_0_1_0_0;
      jira-wiki-markup = super.jira-wiki-markup_1_5_0;
      mime-types = super.mime-types_0_1_1_0;
      pandoc-types = super.pandoc-types_1_23;
      texmath = super.texmath_0_12_6;
    };
  };

  pandoc3 = pkgs.haskellPackages.pandoc.override {
    doctemplates = pkgs.haskellPackages.doctemplates_0_11;
    gridtables = pkgs.haskellPackages.gridtables_0_1_0_0;
    jira-wiki-markup = pkgs.haskellPackages.jira-wiki-markup_1_5_0;
    mime-types = pkgs.haskellPackages.mime-types_0_1_1_0;
    pandoc-types = pkgs.haskellPackages.pandoc-types_1_23;
    texmath = pkgs.haskellPackages.texmath_0_12_6;
    version = "123";
  };

  pandoc_3_1 = pkgs.haskell.lib.doJailbreak pkgs.haskellPackages.pandoc_3_1;
in
{
  home.username = "${values.username}";
  home.homeDirectory = "/home/${values.username}";


  home.packages = [
    pkgs.python3Packages.autopep8
    pkgs.tailscale
    pkgs.cacert
    pkgs.zotero
    pkgs.docker
    pkgs.docker-compose
    pkgs.runc
    pkgs.containerd
    pkgs.doctl
    pkgs.vault
    pkgs.git-filter-repo
    pkgs.kubernetes-helm
    pkgs.inotify-tools
    pkgs.cmctl
    pkgs.elixir
    # pkgs.go-ethereum
    pkgs.awscli2
    pkgs.nebula
    pkgs.asdf-vm
    pkgs.udisks2
    # pkgs.devbox
    pkgs.pam_mount
    pkgs.rc2nix
    pkgs.killall
    pkgs.terraform
    pkgs.nixos-install-tools
    pkgs.ent-go
    pkgs.patchelf
    pkgs.python3
    pkgs.python310Packages.pygments
    pkgs.inetutils
    pkgs.host.dnsutils
    pkgs.nix-alien
    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay

    # pkgs.kdiskmark
    # pkgs.filelight
    # pkgs.bonnie
    # pkgs._7zz
    # pkgs.podman
    # pkgs.shadow
    # pkgs.parallel
    # pkgs.pssh
    # pkgs.polkit
    # pkgs.nixos-generators
    pkgs.wireguard-tools
    pkgs.wireguard-go
    pkgs.kmod
    pkgs.qrencode
    pkgs.coturn
    pkgs.R
    pkgs.inkscape
    pkgs.librsvg

    # hp.pandoc
    # pandoc3
    pkgs.haskellPackages.pandoc
    pkgs.drawio
    pkgs.obsidian
    pkgs.haskellPackages.pandoc-crossref
    pkgs.evince
    pkgs.stuntman
    pkgs.libnatpmp
    pkgs.miniupnpc
    pkgs.gcc
    pkgs.steam-run
    pkgs.nix-ld

    pkgs.strongswan
    pkgs.nmap-unfree
    pkgs.sofia_sip
    pkgs.cachix
    pkgs.devenv



    # pandoc_3_1
    # (pkgs.haskellPackages.pandoc_3_1.override (old: {
    #   libraryHaskellDepends = old.libraryHaskellDepends ++ [ pkgs.haskellPackages.doctemplates_0_11 ];
    # }))


    pkgs.rstudio
    pkgs.screen
  ] ++ [ ];


  programs.texlive = {
    enable = true;
    # extraPackages = tpkgs: {
    #   scheme-full = pkgs.texlive.scheme-full // {
    #     pkgs = pkgs.lib.filter
    #       (x: (x.pname != "markdown"))
    #       pkgs.texlive.scheme-full.pkgs;
    #   };
    # kpathsea = tpkgs.kpathsea;

    #   scheme-custom.pkgs = [ markdown ];
    # };
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

    initExtra = ''
      command -v wg > /dev/null && . ~/.nix-profile/share/bash-completion/completions/wg
      command -v wg-quick > /dev/null && . ~/.nix-profile/share/bash-completion/completions/wg-quick
    '';
  };

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

  # services.gpg-agent = {
  #   enable = true;
  #   defaultCacheTtl = 1800;
  #   # enableSshSupport = true;
  # };

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
