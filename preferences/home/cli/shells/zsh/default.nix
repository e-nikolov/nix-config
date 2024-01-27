{
  config,
  pkgs,
  lib,
  inputs',
  ...
} @ args: {
  imports = [
    ./p10k.nix
    ./terminfo.nix
    ./plugins.nix
    ./completions.nix
    ./functions.nix
    ./opts.nix
    ./direnv.nix
  ];

  home.packages = [];
  home.shellAliases = {
    zfg = "code ~/.zshrc";
    src = "source ~/.zshrc";
    nixpkgs = "web_search nixpkgs ";
  };

  programs.zsh = {
    enable = true;

    initExtraFirst = lib.mkAfter ''
      ${config.lib.shell.exportAll config.home.sessionVariables}
      ${lib.optionalString (config.home.sessionPath != []) ''
          export PATH="$PATH''${PATH:+:}${
            builtins.concatStringsSep ":" config.home.sessionPath
          }"
        ''
        + config.home.sessionVariablesExtra}
    '';

    defaultKeymap = "emacs";

    initExtra = ''
      ### Functions ###
      nhs() {
        home-manager switch --flake ~/nix-config --verbose $@ && exec zsh
      }
      nrs() {
        sudo nixos-rebuild switch --flake ~/nix-config --verbose $@ && exec zsh
      }

      [ -f  ~/nix-config/dotfiles/.zshrc ] && . ~/nix-config/dotfiles/.zshrc
    '';
  };
}
