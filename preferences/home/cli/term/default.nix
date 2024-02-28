{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./hyper.nix
    ./yakuake.nix
    ./winterm.nix
    ./tabby.nix
    ./wezterm.nix
  ];

  fonts.fontconfig.enable = true;
  home = {
    packages = [
      # * FONTS
      pkgs.meslo-lgs-nf
      pkgs.fira-code
      pkgs.jetbrains-mono
      pkgs.noto-fonts-monochrome-emoji

      pkgs.xterm
    ];

    file = {
      ".local/bin/zotero.sh".source = ./zotero.sh;
    };
  };
  programs = {
    kitty.enable = true;
  };
}
