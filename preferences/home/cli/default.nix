{
  config,
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./shells
    ./nvim
    ./zoxide.nix
    ./carapace.nix
    ./git.nix
    ./ssh.nix
    ./bat.nix
    ./fzf.nix
    ./gpg.nix
    ./helix
    inputs.nix-index-database.hmModules.nix-index
  ];

  home.packages = [
    # * Dev
    pkgs.gnumake
    pkgs.websocat

    # * Utils
    pkgs.xdg-utils
    pkgs.neofetch
    pkgs.lsof
    pkgs.jq
    pkgs.file
    pkgs.tmux
    pkgs.curl
    pkgs.rsync
    pkgs.tldr

    pkgs.nb

    # Nix
    pkgs.devenv
    pkgs.cachix
    pkgs.rnix-lsp
    pkgs.nixos-option
    pkgs.nix-doc
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    pkgs.nil
    pkgs.nixd
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix
    pkgs.manix
    (pkgs.stdenv.mkDerivation {
      name = "nix-index";
      buildInputs = [pkgs.nix-index-unwrapped];
      buildCommand = ''
        mkdir -p $out/bin
        cp ${pkgs.nix-index-unwrapped}/bin/nix-index $out/bin/
      '';
    })
  ];
  programs = {
    nix-index-database.comma.enable = lib.mkDefault true;

    htop.enable = true; # task manager
    eza.enable = true; # modern ls
    micro.enable = true; # editor

    # readline.enable = true;
    # gitui.enable = true;
    # pls.enable = true;
  };
}
