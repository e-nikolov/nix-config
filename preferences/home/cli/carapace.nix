{
  config,
  pkgs,
  lib,
  me,
  inputs,
  ...
}: {
  imports = [
    ../../../modules/home/carapace.nix
  ];
  programs.carapace.enable = true;
}
