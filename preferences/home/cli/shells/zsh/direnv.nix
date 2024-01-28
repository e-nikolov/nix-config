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
        eval "$(${config.programs.direnv.package}/bin/direnv export zsh)" || true
      '';

      initExtra = lib.mkOrder 3000 ''
        op-env() {
            [[ -f .oprc ]] || return 0

            command -v op >/dev/null || return 0 && local OP_CMD="op"
            command -v op.exe >/dev/null || return 0 && local OP_CMD="op.exe"
            eval "$(cat .oprc | ''${OP_CMD} inject)"
        }

        eval "$(${config.programs.direnv.package}/bin/direnv hook zsh)" || true
      '';
    };
  };
}
