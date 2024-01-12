{
  config,
  pkgs,
  lib,
  personal-info,
  inputs,
  outputs,
  ...
}:
with lib; {
  imports = [
    ../../../modules/home/carapace.nix
  ];
  programs.carapace.enable = true;
}
