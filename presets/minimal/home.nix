args@{ config, pkgs, lib, inputs, ... }: {
  imports = [
    ../starter/home.nix
    ../../preferences/home/cli
    inputs.nix-colors.homeManagerModule
  ];
  nixpkgs.config.permittedInsecurePackages = [
    # home-manager
    pkgs.openssl_1_1.name
    "electron-25.9.0" # obsidian https://github.com/NixOS/nixpkgs/issues/273611
  ];

  home.packages = [
    # pkgs.fortune
    # pkgs.hello
    # pkgs.cowsay
  ] ++ [ ];

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
