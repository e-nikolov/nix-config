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
  programs.zsh.initExtra = mkAfter ''
    [ -f  ~/nix-config/dotfiles/.zshrc ] && . ~/nix-config/dotfiles/.zshrc
  '';
}
