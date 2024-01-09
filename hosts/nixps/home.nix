{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: {
  imports = [
    ../../modules/common/home.nix
    ../../modules/home-manager/keyboard
    ../../modules/home-manager/wm/plasma
    ../../modules/home-manager/cli/term
    ../../modules/home-manager/vscode
  ];
  # xdg.mimeApps.enable = true; # TODO

  home.packages = [
    #* Browsers
    pkgs.firefox
    pkgs.microsoft-edge-beta
    pkgs.microsoft-edge
    # pkgs.brave
    # pkgs.vivaldi
    #pkgs.chromium

    #* Messengers
    # pkgs.slack
    # pkgs.viber

    #* Audio
    pkgs.qpwgraph
    # pkgs.carla
    # pkgs.jack2
    # pkgs.jackmix
    # pkgs.qjackctl
    # pkgs.paprefs
    # pkgs.pamix

    #* Dev
    pkgs.python3
    pkgs.python310Packages.pygments
    pkgs.sublime4
    pkgs.sublime-merge
    #pkgs.libsForQt5.kate
    pkgs.obsidian
    pkgs.zotero

    #* Utils
    pkgs.unrar
    pkgs.ark
    pkgs.parted
    pkgs.xdotool
    pkgs.xorg.xev

    #* Media
    pkgs.popcorntime
    pkgs.vlc
    pkgs.krita

    #* Office
    pkgs.libreoffice-qt
    pkgs.libsForQt5.kio-gdrive
  ];
}
