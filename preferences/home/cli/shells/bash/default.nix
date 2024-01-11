{
  config,
  pkgs,
  lib,
  inputs,
  ...
} @ args: {
  programs.bash = {
    enable = lib.mkDefault true;

    initExtra = lib.mkDefault ''
      ### Functions ###

      if [[ $XDG_SESSION_TYPE == "wayland" ]]; then
        xc() {
            wl-copy
        }
      else
        xc() {
            xclip -selection clipboard
        }
      fi

      nhs() {
        home-manager switch --flake ~/nix-config $@ && exec bash
      }

      nrs() {
        sudo nixos-rebuild switch --flake ~/nix-config/ $@ && exec bash
      }

      function ww() {
          local paths=()
          local lines=()
          while IFS= read -r line; do
              if [[ $line =~ ^/ ]]; then
                  paths+=("$line")
              else
                  lines+=("$line")
              fi
          done < <(which "$@")

          if [[ ! ''${#paths[@]} -eq 0 ]]; then
              realpath $paths | xargs eza -alh --group-directories-first --color always --icons
          fi

          for i in $lines; do
              echo $i
          done
      }

      function has_flag() {
          local flag_pattern=$1
          shift

          local positional=()
          while (($#)); do
              opt=$1
              shift

              if [[ $opt =~ ^$flag_pattern ]]; then
                  return 1
              fi
          done
      }

      function nd() {
          has_flag "-c|--command" "$@"
          local hf=$?
          if [ $hf = 1 ]; then
              nix develop "$@"
          else
              nix develop "$@" --command bash
          fi
      }

      nar() {
        path=$1
        cache=$2

        if [ -z "$cache" ]; then
          cache="https://cache.nixos.org/"
        fi

        path=$(echo "/nix/store/cw63r63gnm62rny5xx0apri8qywzx98j-file-5.45" | sed -n 's/\/nix\/store\/\([a-zA-Z0-9]*\)-.*/\1/p')
        url="https://$cache$path.narinfo"
        curl -L $url
      }

      [ -f  ~/nix-config/dotfiles/.bashrc ] && . ~/nix-config/dotfiles/.bashrc
    '';
  };
}
