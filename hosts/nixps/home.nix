{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: {
  imports = [../../presets/base/home.nix ../../presets/desktop/home.nix];

  home.packages = [
    #* Audio
    pkgs.qpwgraph
    # pkgs.carla
    # pkgs.jack2
    # pkgs.jackmix
    # pkgs.qjackctl
    # pkgs.paprefs
    # pkgs.pamix
  ];
}
