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
  ] ++ [ ];


  programs.texlive = {
    enable = true;
    extraPackages = tpkgs: {
      scheme-full = pkgs.texlive.scheme-full // {
        pkgs = pkgs.lib.filter
          (x: (x.pname != "markdown"))
          pkgs.texlive.scheme-full.pkgs;
      };
      kpathsea = tpkgs.kpathsea;

      scheme-custom.pkgs = [ markdown ];
    };
  };

  nix.settings.extra-platforms = [ "armv7l-linux" "armv7l-hf-multiplatform" "armv7l-multiplatform" "aarch64-linux" ];
  nix.settings.cores = 4;
  # nix.settings.trusted-substituters = [ "https://cache.armv7l.xyz" ];
  # nix.settings.substituters = [ "https://cache.armv7l.xyz" ];

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
