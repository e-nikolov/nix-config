{ config, pkgs, values, inputs, ... }:
{
  home.username = "${values.username}";
  home.homeDirectory = "/home/${values.username}";

  home.packages = [
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
    # pkgs.texlive.combined.scheme-full
  ] ++ [ ];


  nix.settings.extra-platforms = [ "armv7l-linux" "armv7l-hf-multiplatform" "armv7l-multiplatform" ];
  nix.settings.cores = 4;
  # nix.settings.trusted-substituters = [ "https://cache.armv7l.xyz" ];
  # nix.settings.substituters = [ "https://cache.armv7l.xyz" ];

  programs.zsh = {
    enable = true;
    initExtra = ''

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
