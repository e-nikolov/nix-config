{
  config,
  pkgs,
  lib,
  pkgs-stable,
  inputs,
  ...
} @ args: {
  programs.nushell = {
    enable = true;
    package = pkgs.nushellFull;
    configFile.source = ./config.nu;
    extraEnv = ''
    '';
    extraConfig = ''
    '';

    shellAliases = {
    };
  };
}
