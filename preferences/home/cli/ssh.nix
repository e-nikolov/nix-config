{ config, pkgs, lib, personal-info, inputs, outputs, ... }:
let cfg = config.services.ssh-agent;
in {
  home.packages = [ pkgs.gnupg pkgs.sops pkgs.age pkgs.xxh ];
  services.ssh-agent.enable = lib.mkDefault true;
  programs.zsh = {
    initExtraFirst = lib.mkIf cfg.enable (lib.mkAfter ''
      # zstyle :omz:plugins:ssh-agent agent-forwarding yes
      # zstyle :omz:plugins:ssh-agent helper ksshaskpass
      # zstyle :omz:plugins:ssh-agent lazy yes
      # zstyle :omz:plugins:ssh-agent quiet yes
      # zstyle :omz:plugins:ssh-agent lifetime 5h
      # zstyle :omz:plugins:ssh-agent identities id_rsa
    '');
  };

  programs.ssh = {
    forwardAgent = lib.mkDefault true;
    enable = lib.mkDefault true;
    extraConfig = ''
      AddKeysToAgent yes
    '';
  };
}
