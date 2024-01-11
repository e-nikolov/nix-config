{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [
    ./shells/zsh
    ./shells/fish
    ./shells/bash
    ./shells/nushell
    ./nvim
    ./zellij
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.nix-index-database.comma.enable = lib.mkDefault true;
  home.packages = [
    # pkgs.stable.ripgrep-all
    # pkgs.ripgrep-all
    pkgs.websocat
    pkgs.gnumake
    pkgs.lsof
    pkgs.readline
    pkgs.fasd

    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay
    pkgs.jq
    pkgs.direnv
    pkgs.xclip
    pkgs.wl-clipboard

    pkgs.bash-completion
    pkgs.tmux
    pkgs.file

    pkgs.rnix-lsp
    pkgs.xxh
    pkgs.nixos-option
    pkgs.nix-doc
    pkgs.xdg-utils
    pkgs.micro
    pkgs.htop
    pkgs.curl
    pkgs.git
    pkgs.tldr
    pkgs.rsync
    pkgs.gnupg
    pkgs.sops
    pkgs.age
    pkgs.delta
    pkgs.most
    pkgs.sd-switch
    (pkgs.stdenv.mkDerivation {
      name = "nix-index";
      buildInputs = [pkgs.nix-index-unwrapped];
      buildCommand = ''
        mkdir -p $out/bin
        cp ${pkgs.nix-index-unwrapped}/bin/nix-index $out/bin/
      '';
    })
    pkgs.devenv
    pkgs.nixfmt
    pkgs.nixpkgs-fmt
    pkgs.nil
    pkgs.nixd
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix
    pkgs.manix
    pkgs.nb
    pkgs.bat
  ];
  systemd.user.startServices = "sd-switch";

  # FIXME: This is not working for zsh
  home.sessionPath = ["$HOME/.local/bin" "$HOME/.npm-packages/bin"];
  home.sessionVariables = {
    NODE_PATH = lib.mkDefault "$HOME/.npm-packages/lib/node_modules";
    HOME_MANAGER_CONFIG = lib.mkDefault "$HOME/nix-config";
  };

  colorscheme = lib.mkDefault colorSchemes.dracula;
  programs.bat.enable = true;
  programs.carapace.enable = lib.mkAfter true;
  programs.htop.enable = true;
  programs.eza.enable = true;
  programs.git = {
    enable = true;
    # difftastic = {
    #   enable = true;
    #   background = "dark";
    #   color = "always";
    #   display = "side-by-side-show-both";
    # };

    delta.enable = true;

    extraConfig = {
      core = {editor = lib.mkDefault "micro";};
      credential = {helper = lib.mkDefault "cache --timeout=3600";};

      pull = {ff = lib.mkDefault "only";};
    };
  };
  # services.gpg-agent.enable = true;
  # services.gpg-agent.enableSshSupport = true;
  # services.gpg-agent.defaultCacheTtl = 3600;

  services.ssh-agent.enable = true;
  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };

  programs.starship.enable = true;
  programs.starship.enableTransience = true;
  programs.starship.enableZshIntegration = false;
  programs.ion.enable = true;

  programs.yazi.enable = true;
  programs.yazi.enableZshIntegration = true;
  programs.yazi.enableBashIntegration = true;
  programs.yazi.enableNushellIntegration = true;
  programs.yazi.enableFishIntegration = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  home.shellAliases = {
    nfe = lib.mkDefault "$EDITOR ~/nix-config/ ";
    ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
    nfu = lib.mkDefault "nix flake update ~/nix-config ";
    nh = lib.mkDefault "home-manager --flake ~/nix-config ";
    ns = lib.mkDefault "nix shell ";
    # nd = lib.mkDefault "nix develop ";
    gst = lib.mkDefault "git status ";
    gcl = lib.mkDefault "git clone --recurse-submodules ";
    gc = lib.mkDefault "git commit ";
    sudo = lib.mkDefault ''sudo -E env "PATH=$PATH" '';
  };

  # programs.readline.enable = true;
  # programs.gitui.enable = true;
  # programs.pls.enable = true;

  fonts.fontconfig.enable = true;
}
