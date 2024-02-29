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
      sudo = ''sudo -E env "PATH=$PATH" '';
      xargs = "xargs ";
      grep = "grep --color --ignore-case --line-number --context=3 ";
    };
  };
}
