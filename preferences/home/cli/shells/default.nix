{
  config,
  pkgs,
  id,
  inputs,
  lib,
  ...
}: let
  inherit (inputs.nix-colors) colorSchemes;
in {
  imports = [./zsh ./fish ./bash ./nushell ./starship.nix];

  # FIXME: This is not working for zsh
  home = {
    sessionPath = ["$GOBIN"];

    sessionVariables = {
      NODE_PATH = lib.mkDefault "$HOME/.npm-packages/lib/node_modules";
      HOME_MANAGER_CONFIG = lib.mkDefault "$HOME/nix-config";
      TERM = "xterm-256color";
      COLORTERM = "truecolor";
      GOBIN = "$HOME/go/bin";
      GOMODCACHE = "$HOME/go/pkg/mod";
      GOPATH = "$HOME/go";
    };
    shellAliases = {
      nfe = lib.mkDefault "$EDITOR ~/nix-config/ ";
      ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
      nfu = lib.mkDefault "nix flake update --flake ~/nix-config ";
      nh = lib.mkDefault "home-manager --flake ~/nix-config ";
      ns = lib.mkDefault "nix shell ";
      ndr = lib.mkDefault "nix-direnv-reload ";
      # nd = lib.mkDefault "nix develop ";
      sudo = lib.mkDefault ''sudo -E env "PATH=$PATH" '';
      xargs = "xargs ";

      l = "eza";
      ls = "eza -olh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree = "eza --tree -alh --group-directories-first --color always --icons ";
      grep = "grep --color --ignore-case --line-number --context=3 ";
      df = "df -h ";

      port = "sudo lsof -i -P -n | fzf";
      pp = "ps axww -o pid,user,%cpu,%mem,start,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

      gi = "go install ./...";
      gomt = "go mod tidy";

      d = "docker";
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcr = "docker-compose run";
      dclt = "docker-compose logs --follow --tail=100";
      colors = ''for i in {0..255}; do print -Pn "%K{$i}  %k%F{$i}''${(l:3::0:)i}%f " ''${''${(M)$((i%6)):#3}:+$'\n'}; done'';

      tf = "terraform";
      x = "xdg-open";
    };

    packages = [pkgs.vivid];
  };
  colorscheme = lib.mkDefault colorSchemes.dracula;
  programs = {
    ion.enable = true;

    yazi = {
      enable = true;
      enableZshIntegration = true;
      enableBashIntegration = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
    };
  };
}
