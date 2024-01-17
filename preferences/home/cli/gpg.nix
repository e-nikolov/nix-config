{ config, pkgs, lib, personal-info, inputs, outputs, ... }:
let
  gpgPkg = config.programs.gpg.package;
  cfg = config.services.gpg-agent;
in {
  home.packages = [ pkgs.sops pkgs.gnupg pkgs.age ];
  services.gpg-agent.enable = lib.mkDefault false;
  services.gpg-agent.enableSshSupport = lib.mkIf cfg.enable true;
  services.gpg-agent.defaultCacheTtl = lib.mkIf cfg.enable 3600;
  services.gpg-agent.enableZshIntegration = lib.mkIf cfg.enable false;

  programs.zsh = {
    initExtraFirst = lib.mkIf cfg.enable (lib.mkAfter ''
      export GPG_TTY=$TTY
    '');
    initExtra = lib.mkIf cfg.enable (lib.mkAfter ''
      ${gpgPkg}/bin/gpg-connect-agent updatestartuptty /bye > /dev/null
    '');
  };
}
