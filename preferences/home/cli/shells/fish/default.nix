{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  programs.fish = {
    enable = true;
    interactiveShellInit = ''
      bind \b backward-kill-word
      bind \e\[3\;5~ kill-word
      # # Define global variable to hold the mark position
      # set -g MARK 0

      # # Set the mark to the current cursor position
      # function set-mark
      #     set MARK (commandline -C)
      # end

      # # Jump to the mark
      # function jump-mark
      #     if test -n "$MARK"
      #         commandline -C $MARK
      #     end
      # end

      # # Move cursor one word to the right and set mark if not set
      # function select-forward-word
      #     if test -z "$MARK"
      #         set MARK (commandline -C)
      #     end
      #     commandline -f forward-word
      # end

      # # Move cursor one word to the left and set mark if not set
      # function select-backward-word
      #     if test -z "$MARK"
      #         set MARK (commandline -C)
      #     end
      #     commandline -f backward-word
      # end

      # # Clear the mark
      # function clear-mark
      #     set -e MARK
      # end

      # # Bind keys
      # bind \cl 'clear-mark'
      # bind \cm 'set-mark'
      # bind \cj 'jump-mark'
      # bind \cf 'select-forward-word'
      # bind \cb 'select-backward-word'

    '';
    shellAbbrs = {
      # ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
      nfu = "nix flake update --flake ~/nix-config ";
      nh = "home-manager --flake ~/nix-config ";
      ns = "nix shell ";
      # nd = lib.mkDefault "nix develop ";
      gst = "git status ";
      gc = "git commit ";
      gcl = "git clone --recurse-submodules ";
      sudo = ''sudo -E env "PATH=$PATH" '';

      xargs = "xargs ";

      gct = "git commit -am 'tmp'";

      l = "eza";
      ls = "eza -o -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree = "eza --tree -alh --group-directories-first --color always --icons ";
      grep = "grep --color --ignore-case --line-number --context=3 ";
      df = "df -h ";

      zfg = "code ~/.config/fish/config.fish";

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

    functions = {
      xc = "xclip -selection clipboard";
      nhs = "home-manager switch --flake ~/nix-config $argv && exec fish";
      nrs = "sudo nixos-rebuild switch --flake ~/nix-config $argv && exec fish";
    };

    plugins = [
      {
        name = "fzf";
        src = pkgs.fetchFromGitHub {
          owner = "PatrickF1";
          repo = "fzf.fish";
          rev = "85503fbc4b6026c616dd5dc8ebb4cfb82e1ef16c";
          sha256 = "sha256-1/MLKkUHe4c9YLDrH+cnL+pLiSOSERbIZSM4FTG3wF0=";
        };
      }
      {
        name = "autopair";
        src = pkgs.fetchFromGitHub {
          owner = "jorgebucaran";
          repo = "autopair.fish";
          rev = "4d1752ff5b39819ab58d7337c69220342e9de0e2";
          sha256 = "sha256-qt3t1iKRRNuiLWiVoiAYOu+9E7jsyECyIqZJ/oRIT1A=";
        };
      }
      {
        name = "fish-abbreviation-tips";
        src = pkgs.fetchFromGitHub {
          owner = "Gazorby";
          repo = "fish-abbreviation-tips";
          rev = "8ed76a62bb044ba4ad8e3e6832640178880df485";
          sha256 = "sha256-F1t81VliD+v6WEWqj1c1ehFBXzqLyumx5vV46s/FZRU=";
        };
      }
      {
        name = "fasd";
        src = pkgs.fetchFromGitHub {
          owner = "oh-my-fish";
          repo = "plugin-fasd";
          rev = "98c4c729780d8bd0a86031db7d51a97d55025cf5";
          sha256 = "sha256-8JASaNylXAGnWd2IV88juk73b8eJJlVrpyiRZUwHGFQ=";
        };
      }
    ];
  };
}
