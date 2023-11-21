{ config, pkgs, id, inputs, ... }: {
  imports = [ ../../modules/common/home.nix ];

  home.packages = [
    # pkgs.libsForQt5.kate
    # pkgs.emanote
  ];
  home.sessionVariables = { EDITOR = "code-insiders"; };

  home.shellAliases = { code = "code-insiders "; };

  programs.bash.initExtra = ''
    source ~/nix-config/dotfiles/.bashrc
  '';

  programs.zsh = {
    initExtra = ''
      ### Windows WSL2 ###
      if grep -qEi "(Microsoft|WSL)" /proc/sys/kernel/osrelease &> /dev/null ; then
        keep_current_path() {
          printf "\e]9;9;%s\e\\" "$(wslpath -w "$PWD")"
        }
        precmd_functions+=(keep_current_path)

        e() {
          explorer.exe $(wslpath -w $*)
        }

        subl() {
          subl.exe $(wp $*)
        }

        wp() {
          wslpath -w $* | sed s/wsl.localhost/wsl$/g
        }
      fi
    '';
  };
}
