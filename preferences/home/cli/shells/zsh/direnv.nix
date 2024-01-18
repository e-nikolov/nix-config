{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  home.packages = [pkgs.direnv];

  programs = {
    direnv = {
      enable = true; # auto env on cd
      enableZshIntegration = false;
      nix-direnv.enable = true;
    };
    zsh = {
      initExtraFirst = lib.mkOrder 1 ''
        eval "$(${config.programs.direnv.package}/bin/direnv export zsh)"
      '';

      initExtra = lib.mkOrder 3000 ''
        eval "$(${config.programs.direnv.package}/bin/direnv hook zsh)"
      '';
    };
  };
}
