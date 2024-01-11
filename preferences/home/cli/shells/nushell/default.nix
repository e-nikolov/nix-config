{ config, pkgs, lib, pkgs-stable, inputs, ... }@args: {
  programs.nushell = {
    enable = true;

    extraEnv = ''
      $env.config = {
        show_banner: false,

        keybindings: [
          {
            name: fuzzy_history_fzf
            modifier: control
            keycode: char_r
            mode: [emacs , vi_normal, vi_insert]
            event: {
              send: executehostcommand
              cmd: "commandline (
                history
                  | each { |it| $it.command }
                  | uniq
                  | reverse
                  | str join (char -i 0)
                  | fzf --read0 --tiebreak=chunk --layout=reverse  --multi --preview='echo {..}' --preview-window='bottom:3:wrap' --bind alt-up:preview-up,alt-down:preview-down --height=70% -q (commandline)
                  | decode utf-8
                  | str trim
              )"
            }
          },
          {
              name: fzf_history_menu_fzf_ui
              modifier: control
              keycode: char_e
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_history_menu_fzf_ui }
          }
          {
              name: fzf_history_menu_nu_ui
              modifier: control
              keycode: char_w
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_menu_nu_ui }
          }
          {
              name: fzf_dir_menu_nu_ui
              modifier: control
              keycode: char_q
              mode: [emacs, vi_normal, vi_insert]
              event: { send: menu name: fzf_dir_menu_nu_ui }
          }
        ]
      }
    '';
    extraConfig = ''


      ### Functions ###

      def xc [] {
          xclip -selection clipboard
      }

      extern-wrapped nhs [...args] {
        home-manager switch --flake ~/nix-config $args
        exec nu
      }

      extern-wrapped nrs [...args] {
        sudo nixos-rebuild switch --flake ~/nix-config/ $args
        exec nu
      }

      extern-wrapped nd [...args] {
        nix $args --command nu develop
      }
    '';

    shellAliases = {
      # ne = lib.mkDefault "$EDITOR ~/nix-config/ ";
      nfu = "nix flake update ~/nix-config ";
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
      ls =
        "eza -o -lh --group-directories-first --color always --icons --classify --time-style relative --created --changed";
      lsa = "ls -a ";
      tree =
        "eza --tree -alh --group-directories-first --color always --icons ";
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
