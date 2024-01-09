args @ {
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  imports = [
    ../bare/home.nix
    ../home-manager/cli
    inputs.nix-colors.homeManagerModule
  ];
  nixpkgs.config.permittedInsecurePackages = [
    # home-manager
    pkgs.openssl_1_1.name
    "electron-25.9.0" # obsidian https://github.com/NixOS/nixpkgs/issues/273611
  ];

  home.packages =
    [
      # pkgs.stable.ripgrep-all
      # pkgs.ripgrep-all
      pkgs.websocat
      pkgs.rnix-lsp
      pkgs.gnumake
      pkgs.bc
      pkgs.lsof

      # * FONTS
      pkgs.meslo-lgs-nf
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.noto-fonts-monochrome-emoji

      pkgs.neofetch
      pkgs.readline
      pkgs.fasd

      # pkgs.fortune
      # pkgs.hello
      # pkgs.cowsay
    ]
    ++ [];

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
