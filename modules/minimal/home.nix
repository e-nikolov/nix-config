{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  imports = [
    ../bare/home.nix
    ../home-manager/zsh
    ../home-manager/fish
    ../home-manager/bash
    ../home-manager/zellij
  ];
  programs.home-manager.enable = true;

  nixpkgs.config.permittedInsecurePackages = [
    # home-manager
    pkgs.openssl_1_1.name
    "electron-25.9.0" # obsidian https://github.com/NixOS/nixpkgs/issues/273611
  ];

  home.packages =
    [
      pkgs.nix
      pkgs.micro
      pkgs.htop
      pkgs.nixfmt
      pkgs.nixpkgs-fmt
      pkgs.curl
      pkgs.git
      # pkgs.stable.ripgrep-all
      # pkgs.ripgrep-all
      pkgs.websocat
      # pkgs.file
      pkgs.tldr
      pkgs.rsync
      pkgs.rnix-lsp
      pkgs.gnupg
      pkgs.gnumake
      pkgs.bc
      pkgs.lsof

      # * FONTS
      pkgs.meslo-lgs-nf
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.noto-fonts-monochrome-emoji

      pkgs.neofetch
      pkgs.sops
      pkgs.age
      pkgs.xxh
      pkgs.nixos-option
      pkgs.nix-doc
      pkgs.xdg-utils
      pkgs.delta
      pkgs.most
      pkgs.readline
      pkgs.fasd

      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];
  targets.genericLinux.enable = true;
  xdg.enable = true;

  programs.htop.enable = true;

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
  # programs.readline.enable = true;
  # programs.gitui.enable = true;
  # programs.pls.enable = true;
  programs.carapace.enable = lib.mkAfter true;
  programs.eza.enable = true;

  fonts.fontconfig.enable = true;

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
