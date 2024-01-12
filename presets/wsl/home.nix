{
  config,
  pkgs,
  lib,
  ...
}: {
  # programs.git.gpg.ssh.program = "${pkgs._1password-gui}/share/1password/op-ssh-sign";

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
