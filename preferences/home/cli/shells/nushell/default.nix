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
    # package = pkgs.nushell.overrideAttrs (drv: let
    #   src = pkgs.fetchFromGitHub {
    #     owner = "nushell";
    #     repo = "nushell";
    #     rev = "d1c807230b4f35a9d963ce6fee5b72641690fe06";
    #     sha256 = "sha256-T+0kdTOqtf+zL1+9gVeC5Xf6q2XXCOMOUnuOskeGvuA=";
    #   };
    # in {
    #   inherit src;
    #   cargoDeps = pkgs.rustPlatform.importCargoLock {
    #     lockFile = ./Cargo.lock;
    #     outputHashes = {
    #       "reedline-0.28.0" = "sha256-GFuSsjRK8LUX2WfUM1prbuFO14nP6WozwAKC2p/SGKg=";
    #     };
    #   };
    # });
    configFile.source = ./config.nu;
    extraEnv = ''
    '';
    extraConfig = ''
    '';

    shellAliases = {
      # ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
      nfu = "nix flake update --flake ~/nix-config ";
      nh = "home-manager --flake ~/nix-config ";
      ns = "nix shell ";
      # nd = lib.mkDefault "nix develop ";
      gst = "git status ";
      gc = "git commit ";
      gcl = "git clone --recurse-submodules ";
      ga = "git add ";

      sudo = ''sudo -E env "PATH=$PATH" '';

      xargs = "xargs ";

      gct = "git commit -am 'tmp'";

      l = "eza";
      ls = "eza -o -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree = "eza --tree -alh --group-directories-first --color always --icons ";
      grep = "grep --color --ignore-case --line-number --context=3 ";
      df = "df -h ";

      zfg = "code ~/.zshrc";
      # src = "source ~/.zshrc";

      # port = "sudo lsof -i -P -n | fzf";
      # pp = "ps axww -o pid,user,%cpu,%mem,start,time,command | fzf | sed 's/^ *//' | cut -f1 -d' '";

      gi = "go install ./...";
      gomt = "go mod tidy";

      d = "docker";
      dc = "docker-compose";
      dcu = "docker-compose up";
      dcr = "docker-compose run";
      dclt = "docker-compose logs --follow --tail=100";

      tf = "terraform";
      x = "xdg-open";
      nixpkgs = "web_search nixpkgs ";
    };
  };
}
